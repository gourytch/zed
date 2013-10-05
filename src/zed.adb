with Ada.Text_IO;
with AWS.Config;
with AWS.Default;
with AWS.Server;

with AWS.Response;
with AWS.Status;
with AWS.Messages;
with AWS.MIME;

with Handlers;
with Page_Not_Found;

procedure Zed is
   Web_Server : AWS.Server.HTTP;
   Server_Config : constant AWS.Config.Object := AWS.Config.Get_Current;
   use Ada.Text_IO;
   use AWS.Config;

   procedure Show_Config is
      Config : constant AWS.Config.Object := AWS.Server.Config(Web_Server);
   begin
      Put_Line ("Server Host: " & Server_Host (Config));
      Put_Line ("Server Port: " & Natural'Image (Server_Port (Config)));
      if Session (Config) then
         Put_Line ("with session support");
      else
         Put_Line ("without session support");
      end if;

      if Security (Config) then
         Put_Line ("use secured connection");
      else
         Put_Line ("use insecured connection");
      end if;
   end Show_Config;


   procedure Perform_Good_Start is
   begin

      AWS.Server.Start (Web_Server => Web_Server,
                        Dispatcher => Handlers.Get_Dispatcher,
                        Config     => Server_Config);
   end Perform_Good_Start;

   procedure Perform_HardCoded_Start is
   function Callback
     (Request : in AWS.Status.Data)
      return AWS.Response.Data
   is
      Resource : constant String := AWS.Status.URI (Request);
   begin
      return AWS.Response.Build
        (Status_Code => AWS.Messages.S200,
         Content_Type => AWS.MIME.Text_HTML,
         Message_Body => "HELLO!");
   end Callback;

   begin
      AWS.Server.Set_Security (Web_Server => Web_Server,
                               Certificate_Filename => "./zed.pem");
      AWS.Server.Start (Web_Server => Web_Server,
                        Name       => Server_Name (Server_Config),
                        Callback   => Callback'Unrestricted_Access,
                        Port       => Server_Port (Server_Config),
                        Session    => True,
                        Security   => True);
   end Perform_HardCoded_Start;



begin
   Put_Line ("server starting ...");

--     Perform_HardCoded_Start;
   Perform_Good_Start;
   Show_Config;

   Put_Line ("server started. perss <q> to quit ...");

   AWS.Server.Wait (AWS.Server.Q_Key_Pressed);
   Put_Line ("server shutting down...");
   AWS.Server.Shutdown (Web_Server);
   Put_Line ("server stopped.");
end Zed;
