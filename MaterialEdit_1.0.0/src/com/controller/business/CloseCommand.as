package com.controller.business
{
	
	import com.model.*;
	import com.view.mediator.MainMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 关闭
	 * @author 王明凡
	 */
	public class CloseCommand extends SimpleCommand
	{
		//(通知)
		public static const CC_CLOSE:String="cc_close";
		private var bindableP:BindableProxy;
		private var materialP:MaterialProxy;
	    private var stateP:StateProxy;
	    		
		public function CloseCommand()
		{
			super();
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
			stateP=this.facade.retrieveProxy(StateProxy.NAME)as StateProxy;		
		}
		override public function execute(note:INotification):void
		{
			try
			{
				//模型层垃圾清理
				bindableP.clear();
				materialP.clear();
				stateP.clear();
				//发送关闭其他通知
				this.sendNotification(MainMediator.MEMM_CLOSE_COMPLETE);			
			}catch(er:Error)
			{
				this.sendNotification(ExceptionCommand.EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}
	}
}