package {
	import flash.display.MovieClip;

	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;
	
	public class PlayerSay extends MovieClip{
		
		//these three variables are required by the engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;
		
		public var oldChatSay:Function = null;
		public var unloaded:Boolean = false;
		
		public var allowTeam:Boolean = true;
		public var allowAll:Boolean = true;
		
		//constructor, you usually will use onLoaded() instead
		public function PlayerSay() : void {
			trace("[PlayerSay] PlayerSay UI Constructed!");
			trace('335');
		}
		
		//this function is called when the UI is loaded
		public function onLoaded() : void {			
			trace("[PlayerSay] Loaded");
			oldChatSay = globals.Loader_hud_chat.movieClip.gameAPI.ChatSay;
			globals.Loader_hud_chat.movieClip.gameAPI.ChatSay = function(obj:Object, bool:Boolean){
				var type:int = globals.Loader_hud_chat.movieClip.m_nLastMessageMode
				if (bool)
					type = 4
				
				if (!unloaded)
					gameAPI.SendServerCommand( "player_say " + type + " " + obj.toString());
				
				if (type == 4 || type == 3 || (type == 2 && allowTeam) || ((type > 4 || type < 2) &&  allowAll))
					oldChatSay(obj, bool);
				else
					oldChatSay("", bool);
			};
			
			
			this.gameAPI.SubscribeToGameEvent("player_say_config", this.onPlayerSayConfig);
		}
		
		public function onUnloaded() : void {
			trace("[PlayerSay] Unloaded");
			unloaded = true;
			//globals.Loader_hud_chat.movieClip.gameAPI.ChatSay = oldChatSay;
			//oldChatSay = null;
		}
		
		public function onPlayerSayConfig(obj:Object){
			var local = globals.Players.GetLocalPlayer();
			
			if (obj.pid == local || obj.pid == -1){
				allowTeam = obj.allowTeam;
				allowAll = obj.allowAll;
			}
		}
		
		//this handles the resizes - credits to Nullscope
		public function onResize(re:ResizeManager) : * {
			
		}
	}
}