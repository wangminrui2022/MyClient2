package com.controller.business
{
	import com.core.consts.MString;
	import com.model.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 编辑状态更新
	 * @author wangmingfan
	 */
	public class EditStateCommand extends SimpleCommand
	{
		//修改状态(通知)
		public static const ESC_EDITSTATE:String="esc_editstate";	
				
		private var stateP:StateProxy;
		private var uiP:UIProxy;
		private var materialP:MaterialProxy;	
			
		public function EditStateCommand()
		{
			super();
			stateP=this.facade.retrieveProxy(StateProxy.NAME) as StateProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;			
		}
		override public function execute(note:INotification):void
		{
			var bol:Boolean=note.getBody() as Boolean;
			stateP.saveState=bol;
			if(bol)
			{
				uiP.app.title=MString.TITLE+" - "+materialP.miVO.materialPath+" *";				
			}
			else
			{
				uiP.app.title=MString.TITLE+" - "+materialP.miVO.materialPath;				
			}
			stateP=null;
			uiP=null;
			materialP=null;		
		}		
	}
}