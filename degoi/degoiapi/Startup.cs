using Microsoft.AspNet.SignalR;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(degoiapi.Startup))]
namespace degoiapi {
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            app.UseCors(Microsoft.Owin.Cors.CorsOptions.AllowAll);
            ConfigureAuth(app);
            app.MapSignalR();
            GlobalHost.HubPipeline.RequireAuthentication();
        }
    }
}