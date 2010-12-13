# Ground Service

# =======
# Service
# =======
print("Starting ground service...");

servicedevice = "/controls/groundservice/pax/active";
props.Node.new(servicedevice);
setprop(servicedevice, "false");

servicedevice = "/controls/groundservice/cargo/active";
props.Node.new(servicedevice);
setprop(servicedevice, "false");

serviceonoffPax = func {
    servicedevice = "/controls/groundservice/pax/active";
    servicedeviceoff = "/controls/groundservice/cargo/active";
    
    valueservice = getprop(servicedevice);
    valueserviceoff = getprop(servicedeviceoff);
    
    if(valueservice == 0 or valueservice == nil) {
    	setprop(servicedevice, "true" );
    	if (valueserviceoff == 1 ) {
    		setprop(servicedeviceoff, "false" );
    	}
    } else {
    	setprop(servicedevice, "false" );
	}
}

serviceonoffCargo = func {
    servicedevice = "/controls/groundservice/cargo/active";
    servicedeviceoff = "/controls/groundservice/pax/active";
    
    valueservice = getprop(servicedevice);
    valueserviceoff = getprop(servicedeviceoff);
    
    if(valueservice == 0 or valueservice == nil) {
    	setprop(servicedevice, "true" );
    	if (valueserviceoff == 1) {
    		setprop(servicedeviceoff, "false" );
    	}
    } else {
    	setprop(servicedevice, "false" );
	}
}


print("[OK]");

