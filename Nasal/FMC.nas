# Create initial announced variables at startup of the sim
V1 = "135";
VR = "145";
V2 = "160";

# The actual function
var vspeeds = func {

       # Create/populate variables at each function cycle
       # Retrieve total aircraft weight and convert to kg.
	WT = getprop("/fdm/jsbsim/inertia/weight-lbs")*0.00045359237;
	flaps = getprop("/instrumentation/fmc/to-flap");

       # Calculate V-speeds with flaps 10
	if (flaps == 10) {
		V1 = (0.3*(WT-200))+100;
		VR = (0.3*(WT-200))+115;
		V2 = (0.3*(WT-200))+135;
	}

       # Calculate V-speeds with flaps 20
	elsif (flaps == 20) {
		V1 = (0.3*(WT-200))+95;
		VR = (0.3*(WT-200))+110;
		V2 = (0.3*(WT-200))+130;
	}

       # Export the calculated V-speeds to the property-tree, for further use
	setprop("/instrumentation/fmc/vspeeds/V1",V1);
	setprop("/instrumentation/fmc/vspeeds/VR",VR);
	setprop("/instrumentation/fmc/vspeeds/V2",V2);

       # Repeat the function each second
	settimer(vspeeds, 1);
}

# Only start the function when the FDM is initialized, to prevent the problem of not-yet-created properties.
_setlistener("/sim/signals/fdm-initialized", vspeeds);


setlistener("/sim/signals/fdm-initialized", func {
   copilot.init();
});

# Copilot announcements
var copilot = {
   init : func { 
       me.UPDATE_INTERVAL = 1.73; 
       me.loopid = 0;
       # Initialize state variables.
       me.V1announced = 0;
       me.VRannounced = 0;
       me.V2announced = 0;
       me.reset(); 
       print("Copilot ready"); 
   }, 
   update : func {
       var airspeed = getprop("velocities/airspeed-kt");
       var V1 = getprop("/instrumentation/fmc/vspeeds/V1");
       var V2 = getprop("/instrumentation/fmc/vspeeds/V2");
       var VR = getprop("/instrumentation/fmc/vspeeds/VR");

       #Check if the V1, VR and V2 callouts should occur and if so, add to the announce function
       if ((airspeed != nil) and (V1 != nil) and (airspeed > V1) and (me.V1announced == 0)) {
           me.announce("V1!");
               me.V1announced = 1;

       } elsif ((airspeed != nil) and (VR != nil) and (airspeed > VR) and (me.VRannounced == 0)) {
           me.announce("VR!");
               me.VRannounced = 1;

       } elsif ((airspeed != nil) and (V2 != nil) and (airspeed > V2) and (me.V2announced == 0)) {
           me.announce("V2!");
               me.V2announced = 1;
       }
   },

   # Print the announcement on the screen
   announce : func(msg) {
       setprop("/sim/messages/copilot", msg);
   },
   reset : func {
       me.loopid += 1;
       me._loop_(me.loopid);
   },
   _loop_ : func(id) {
       id == me.loopid or return;
       me.update();
       settimer(func { me._loop_(id); }, me.UPDATE_INTERVAL);
   }
};
