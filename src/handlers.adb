with Page_Login;
with Page_Not_Found;
with Resource_Handler;

package body Handlers is

   function Get_Dispatcher
      return AWS.Services.Dispatchers.URI.Handler
   is
      Dispatcher : AWS.Services.Dispatchers.URI.Handler;

   begin
      Dispatcher.Register_Default_Callback (Action => Page_Not_Found.Callback);

      Dispatcher.Register_Regexp
        (URI => "^" & Resource_Handler.Resources_Prefix & ".*$",
         Action => Page_Login.Callback);

      Dispatcher.Register (URI    => "/login",
                           Action => Page_Login.Callback);

      return Dispatcher;
   end Get_Dispatcher;

end Handlers;
