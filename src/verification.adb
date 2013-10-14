with Ada.Text_IO;

package body Verification is

   function Verify (Crt : AWS.Net.SSL.Certificate.Object) return Boolean;


   function Callback return AWS.Net.SSL.Certificate.Verify_Callback is
   begin
     return Verify'Access;
   end Callback;


   function Verify (Crt : AWS.Net.SSL.Certificate.Object) return Boolean is
      use AWS.Net.SSL.Certificate;
      use Ada.Text_IO;
   begin
      Put_Line ("Verify CRT with serial number " & Serial_Number (Crt));
      Put_Line ("Subject : " & Subject (Crt));
      Put_Line ("Issuer : " & Issuer (Crt));
      Put_Line ("Status: " & Status_Message (Crt));
      if Verified (Crt) then
         Put_Line ("cerificate already verified");
      else
         Put_Line ("cerificate not verified");
      end if;
      return True; -- STUB
   end Verify;


end Verification;
