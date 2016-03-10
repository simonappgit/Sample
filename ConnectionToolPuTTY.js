<script type="text/javascript">
	function runCustomScript(Password)
	{		
		DebugMsg("Start PuTTY script");
		var WSH;
		try
		{
			WSH = new ActiveXObject("WScript.Shell");
		}
		catch(e)
		{
			HandleError("Cannot open ActiveX.");
		}
		
		//Get properties
		var username = GetProperty("GenericUserName");
		DebugMsg("User name: " + username);
		var address = GetProperty("GenericAddress");
		DebugMsg("Address: " + address);		
		var properties = GetProperty("GenericParameters");					
		var puttyPath = properties["ExePath"].Value;
		DebugMsg("Executable path: " + puttyPath);
		DebugMsg("Password length: " + Password.length);
		
		//Create command
		var sCommand = "\"" + puttyPath + "\" -ssh -pw " + Password + " " + username + "@" + address;
		
		//Run command
		DebugMsg("Running command: " + sCommand) ;
		try
		{
			WSH.run(sCommand, 1, false);									
		}
		catch(e)
		{
			HandleError("Cannot run the putty command");
		}
		setTimeout(WaitForInit, 2000);		
	}

	function WaitForInit()
	{							
		window.close();
	}	
</script>
