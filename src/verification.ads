with AWS.Net.SSL.Certificate;

package Verification is

   function Callback
     return AWS.Net.SSL.Certificate.Verify_Callback;

end Verification;
