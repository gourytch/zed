with AWS.Dispatchers.Callback;

package Resource_Handler is

   Resources_Dirname : constant String := "./resources/";
   Resources_Prefix : constant String := "/resources/";

   function Callback
     return AWS.Dispatchers.Callback.Handler;

end Resource_Handler;
