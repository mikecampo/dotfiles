////////////////////////////////////////////////////////////////////////////
// ADOBE SYSTEMS INCORPORATED
// Copyright 2008-2017 Adobe Systems Incorporated
// All Rights Reserved
//
// NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
// terms of the Adobe license agreement accompanying it.  If you have received this file from a
// source other than Adobe, then your use, modification, or distribution of it requires the prior
// written permission of Adobe.
/////////////////////////////////////////////////////////////////////////////

// Works around the lack of a permanently enabled "Show Items from Subfolders" option (aka flat view). 
// The default behaviour is to turn off the option when changing folders. This extension enables the 
// flat view when the app starts and then keeps it enabled when changing folders. You can disable this 
// behaviour by disabling the "Always Show Items from Subfolders" option.

function AlwaysFlatViewSetting() {
	this.requiredContext = "\tAdobe Bridge must be running.\n";
	this.menuID = "alwaysFlatViewSetting";
}

AlwaysFlatViewSetting.prototype.run = function() {
	if (!this.canRun()) return false;

	var toggleFlatView = function(enable) {
		var task = 'MenuElement.find("FlatView").checked = ' + (enable ? 'true' : 'false');
		app.scheduleTask(task, 0, false);
	}

	var label = "Always Show Items from Subfolders";
	var menuItem = new MenuElement( "command", label, "after FlatView");
	menuItem.canBeChecked = true;
	menuItem.checked      = true;
	menuItem.onSelect     = function() {
		menuItem.checked = !menuItem.checked;
		toggleFlatView(menuItem.checked);
	}

	// Triggered when changing folders or selecting some menu option.
	onSelectItem = function(event) {	
		if (event.object instanceof Document && event.type == "selectionsChanged") {
			if (menuItem.checked) {
				toggleFlatView(true);
			}
			return {handled:false};  // continue handling all other event handlers
		}		
	}
	app.eventHandlers.push({handler: onSelectItem});	
    
	return true;
}

AlwaysFlatViewSetting.prototype.canRun = function() {	
	if (BridgeTalk.appName == "bridge") {
		if (MenuElement.find(this.menuID)) {
			return false; // Item already exists.
		} 
		return true;
	}
	$.writeln("ERROR:: Cannot run AlwaysFlatViewSetting");
	$.writeln(this.requiredContext);
	return false;
}

if (typeof(AlwaysFlatViewSetting_unitTest ) == "undefined") {
	new AlwaysFlatViewSetting().run();
}
