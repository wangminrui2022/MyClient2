/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.controller.start
{
	import com.pureMVC.controller.business.*;
	import com.pureMVC.controller.business.bindable.*;
	import com.pureMVC.controller.business.common.*;
	import com.pureMVC.controller.business.map.*;
	import com.pureMVC.controller.business.material.*;
	import com.pureMVC.controller.business.other.*;
	import com.pureMVC.controller.business.ui.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 注册应用程序所有通知命令
	 * @author wangmingfan
	 */
	public class ControlCommand extends SimpleCommand
	{
		public function ControlCommand()
		{
			super();
		}

		override public function execute(note:INotification):void
		{
			try
			{
				//【bindable包】
				this.facade.registerCommand(SaveStateUpdateCommand.SSUC_SAVE_STATE_UPDATE,SaveStateUpdateCommand);
				this.facade.registerCommand(SetMapUpdateCommand.SMUC_SET_MAP_UPDATE,SetMapUpdateCommand);
				this.facade.registerCommand(SwitchUpdateCommand.SUC_SWITCH_UPDATE,SwitchUpdateCommand);
				
				//【comon包】
				this.facade.registerCommand(AboutCommand.AC_ABOUT,AboutCommand);
				this.facade.registerCommand(BrowseCommand.BC_BROWSE_DIRECTORY,BrowseCommand);
				this.facade.registerCommand(CreateDirectoryCommand.CDC_CREATE_DIRECTORY,CreateDirectoryCommand);
				this.facade.registerCommand(ExceptionCommand.EC_EXCEPTION,ExceptionCommand);
				this.facade.registerCommand(FileCommand.FC_FILE,FileCommand);
				this.facade.registerCommand(Message1Command.MC1_MESSAGE,Message1Command);
				this.facade.registerCommand(Message2Command.MC2_MESSAGE,Message2Command);
				this.facade.registerCommand(ValidateCommand.VC_VALIDATA,ValidateCommand);
				this.facade.registerCommand(PageClearCommand.PC_PAGECLEAR,PageClearCommand);
				this.facade.registerCommand(PrintAlertCommand.PAC_PRINTE_ALERT,PrintAlertCommand);
				this.facade.registerCommand(HelpLoaderCommand.HLC_HELPLOADER,HelpLoaderCommand);

				//【material包】
				this.facade.registerCommand(MaterialLoaderCommand.MLC_MATERIAL_LOADER,MaterialLoaderCommand);
				this.facade.registerCommand(MaterialTileArrCommand.MTC_MATERIALTILEARR,MaterialTileArrCommand);
				this.facade.registerCommand(MaterialObstacleRectCommand.MORC_MATERIAL_OBSTACLE_RECT,MaterialObstacleRectCommand);
				this.facade.registerCommand(URMapMaterialCommand.URMMC_MAP_MATERIAL,URMapMaterialCommand);
				
				//【other包】
				this.facade.registerCommand(ContextMenuSelectCommand.CMSC_CONTEXTMENU_SELECT,ContextMenuSelectCommand);		
				this.facade.registerCommand(MenuItemSelectCommand.MSC_MENUITEM_SELECT,MenuItemSelectCommand);
				this.facade.registerCommand(QuickKeyboardCommand.QKC_QUICK_KEYBOARD,QuickKeyboardCommand);

				//【map包】
				this.facade.registerCommand(BackgroundAndTilesCommand.BATC_BACKGROUND_AND_TILES,BackgroundAndTilesCommand);
				this.facade.registerCommand(GridAndRoadCommand.GARC_GRID_AND_ROAD,GridAndRoadCommand);
				this.facade.registerCommand(MEComand.MC_ME,MEComand);
				this.facade.registerCommand(GetDragObjectsCommand.GDOC_GET_DRAG_OBJECTS,GetDragObjectsCommand);
				this.facade.registerCommand(ObjectsToUI2Commmand.OTUC_OBJECTSTOUI2,ObjectsToUI2Commmand);
				this.facade.registerCommand(MapDragCommand.MDC_SCENE_DRAG,MapDragCommand);
				this.facade.registerCommand(SaveMapCommand.SMC_SAVE_MAP,SaveMapCommand);
				this.facade.registerCommand(CloseMapCommand.CMC_CLOSE_MAP,CloseMapCommand);
				this.facade.registerCommand(LoaderMapCommand.LMC_LOADER_MAP,LoaderMapCommand);
				this.facade.registerCommand(AddObjectsArrayCommand.AOAC_ADD_OBJECTS_ARRAY,AddObjectsArrayCommand);
				this.facade.registerCommand(CopyMapImageCommand.SMIC_COPY_MAP_IMAGE,CopyMapImageCommand);
				
				//【ui包】
				this.facade.registerCommand(CreateMapUI1Command.CMUI1C_CREATE_MAP_UI1,CreateMapUI1Command);
				this.facade.registerCommand(CreateMapUI2Command.CMUI2C_CREATE_MAP_UI2,CreateMapUI2Command);
				this.facade.registerCommand(SwitchDepthCommand.SDC_SWITCH_DEPTH,SwitchDepthCommand);
			
			}
			catch (er:Error)
			{
				this.facade.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}
	}
}