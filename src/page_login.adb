with AWS.Messages;
with AWS.MIME;
with AWS.Response;
with AWS.Status;

package body Page_Login is

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
      Resource : constant String := AWS.Status.URI (Request);
   begin
      return AWS.Response.Build
        (Status_Code => AWS.Messages.S200,
         Content_Type => AWS.MIME.Text_HTML,
         Message_Body =>
           "<p>LOGIN</p>");
   end Generate_Content;

end Page_Login;
