with Ada.Strings.Fixed;
with AWS.Messages;
with AWS.MIME;
with AWS.Response;
with AWS.Status;
with AWS.Resources;
with AWS.Log;
with Main_Log;

package body Resource_Handler is

   function Generate_Content
     (Request : in AWS.Status.Data)
     return AWS.Response.Data;

   function Callback
      return AWS.Dispatchers.Callback.Handler
   is
   begin
      return AWS.Dispatchers.Callback.Create (Generate_Content'Access);
   end Callback;


   function Get_Filename (Resource : String) return String is
      use Ada.Strings.Fixed;
   begin
      -- only files with predefined pefix are allowed
      -- no references to parent directory allowed
      if
        Resource'Length <= Resources_Prefix'Length or else
        Index (Resource, Resources_Prefix, 1) /= 1 or else
        Index (Resource, "..", 1) /= 0 then
         return ""; -- empty string indicated bad resource name
      end if;

      -- add pathname to prefix
      return Resources_Dirname & Resource
        (Resource'First + Resources_Prefix'Length .. Resource'Last);
   end Get_Filename;


   function Generate_Content
     (Request : in AWS.Status.Data)
      return AWS.Response.Data
   is
      Resource : constant String := AWS.Status.URI (Request);
      Filename : constant String := Get_Filename (Resource);
   begin

      AWS.Log.Write (Main_Log.Log, "access for: """ & resource & """");
      if not AWS.Resources.Is_Regular_File (Filename) then
      AWS.Log.Write (Main_Log.Log, """" & resource & """ is inaccessible");
         return AWS.Response.Build
           (Status_Code => AWS.Messages.S403,
            Content_Type => AWS.Mime.Text_Plain,
            Message_Body => "resource """ & Resource & """ is not accessible");
      end if;

      AWS.Log.Write (Main_Log.Log, "return file """ & Filename &"""");
      return AWS.Response.File
        (Status_Code => AWS.Messages.S200,
         Content_Type => AWS.MIME.Content_Type (Filename),
         Filename => Filename);

   end Generate_Content;

end Resource_Handler;
