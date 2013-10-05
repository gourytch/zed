with AWS.Messages;
with AWS.MIME;
with AWS.Response;
with AWS.Status;
with AWS.Templates;

package body Page_Not_Found is

   function Generate_Content
     (Request : in AWS.Status.Data)
     return AWS.Response.Data;

   function Callback
      return AWS.Dispatchers.Callback.Handler
   is
   begin
      return AWS.Dispatchers.Callback.Create (Generate_Content'Access);
   end Callback;


   function Generate_Content
     (Request : in AWS.Status.Data)
      return AWS.Response.Data
   is
      use AWS.Templates;
      Resource : constant String := AWS.Status.URI (Request);
      Translations : Translate_Set;
   begin
      Insert (Translations, Assoc ("RESOURCE", Resource));
      return AWS.Response.Build
        (Status_Code => AWS.Messages.S404,
         Content_Type => AWS.MIME.Text_HTML,
         Message_Body => Parse ("templates/not_found.html", Translations));
   end Generate_Content;

end Page_Not_Found;
