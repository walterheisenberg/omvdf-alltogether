/**
 * Sensors plugin for system information.
 */
// require("js/omv/NavigationPanel.js")
// require("js/omv/PluginMgr.js")
// require("js/omv/data/DataProxy.js")
// require("js/omv/data/Store.js")
// require("js/omv/grid/TBarGridPanel.js")
// require("js/omv/RrdGraphPanel.js")

Ext.ns("OMV.Module.Diagnostics.SysInfo");

/**
 * @class OMV.Module.Diagnostics.SysInfo.TotalDiskUsage
 * @derived Ext.TabPanel
 */

OMV.Module.Diagnostics.SysInfo.TotalDiskUsage = function(config) {
	var initialConfig = {
		title: "Total Disk Usage",
		rrdGraphName: "df_alltogether"
	};
	Ext.apply(initialConfig, config);
	OMV.Module.Diagnostics.SysInfo.TotalDiskUsage.superclass.constructor.call(
		this, initialConfig);
};
Ext.extend(OMV.Module.Diagnostics.SysInfo.TotalDiskUsage, OMV.RrdGraphPanel, {
});
OMV.preg("sysinfo", "system", OMV.Module.Diagnostics.SysInfo.TotalDiskUsage); 
