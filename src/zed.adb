with Ada.Text_IO;
with AWS.Config;
with AWS.Default;
with AWS.Server;
with AWS.Log;

with AWS.Net.SSL;
with AWS.Net.SSL.Certificate;
with Verification;

with Main_Log;
with Handlers;

with res;

procedure Zed is
   use Ada.Text_IO;
   use AWS.Config;

   Server_Config : AWS.Config.Object := Get_Current;
   Actual_Config : AWS.Config.Object;

   Server_CRT_Filename : constant String := "./keys/zed.crt";
   Server_Key_Filename : constant String := "./keys/zed.key";
   Trusted_CA_Filename : constant String := "./keys/ca.crt";
   CRL_Filename        : constant String := "./keys/crl.pem";

   SSL : AWS.Net.SSL.Config;
   Web_Server : AWS.Server.HTTP;

   procedure Prepare_SSL is
   begin
      Put_Line ("* initialize embedded resources ...");
      res.Init;

      Put_Line ("* configure security layer ...");

      AWS.Net.SSL.Initialize
        (SSL,
         Certificate_Filename => Server_CRT_Filename,
         Key_Filename => Server_Key_Filename,
         Exchange_Certificate => True,
         Certificate_Required => True,
         Trusted_CA_Filename => Trusted_CA_Filename,
         CRL_Filename => CRL_Filename);

      AWS.Net.SSL.Certificate.Set_Verify_Callback (SSL, Verification.Callback);
      AWS.Server.Set_SSL_Config (Web_Server, SSL);
   end Prepare_SSL;


   procedure Start_Server is
   begin
      Put_Line ("* server starting ...");
      AWS.Server.Start (Web_Server => Web_Server,
                        Dispatcher => Handlers.Get_Dispatcher,
                        Config     => Server_Config);
   end Start_Server;


   function Check_Config return Boolean is
   begin
      Put_Line ("* check actual server configuration");
      Actual_Config := AWS.Server.Config (Web_Server);

      Put_Line (". Server name: " & Server_Name (Actual_Config));
      Put_Line (". Server host: " & Server_Host (Actual_Config));
      Put_Line (". Server port: " & Natural'Image(Server_Port (Actual_Config)));

      if not Security (Actual_Config) then
         Put_Line ("x Server is not secured!");
         return False;
      end if;
      Put_Line (". Server is secured");

      if not Exchange_Certificate (Actual_Config) then
         Put_Line ("x Server has no Exchange_Certificate option!");
         return False;
      end if;
      Put_Line (". Server has Exchange_Certificate option.");

      if not Certificate_Required (Actual_Config) then
         Put_Line ("x Server has no Certificate_Required option");
         return False;
      end if;
      Put_Line (". Server has Certificate_Required option");

      if not Session (Actual_Config) then
         Put_Line ("x Server is not session aware!");
         return False;
      end if;
      Put_Line (". Server with session support");

      if not Session (Actual_Config) then
         Put_Line ("x Server is not session aware!");
         return False;
      end if;
      Put_Line (". Server with session support");

      Put_Line (". Config was verified");
      return True;
   end Check_Config;


begin

   AWS.Log.Start (Main_Log.Log,
                  Split => AWS.Log.Each_Run,
                 Filename_Prefix => "main_log");
   Prepare_SSL;
   Start_Server;
   if Check_Config then
      Put_Line ("* server started. perss <q> to quit ...");
      AWS.Server.Wait (AWS.Server.Q_Key_Pressed);
      Put_Line ("* server shutting down...");
   end if;
   AWS.Server.Shutdown (Web_Server);
   Put_Line ("* server stopped.");
   AWS.Log.Stop (Main_Log.Log);

   end Zed;
