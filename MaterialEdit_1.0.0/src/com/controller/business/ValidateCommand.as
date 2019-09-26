/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.controller.business
{
	import com.consts.Msg;
	import com.vo.ValidateErrorVO;
	import com.vo.ValidateVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 验证
	 * @author Administrator
	 */
	public class ValidateCommand extends SimpleCommand
	{
		//验证(通知)
		public static const VC_VALIDATA:String="vc_validata";
		//验证结果(通知)
		public static const VC_VALIDATA_RESULT:String="vc_validata_result";
				
		public function ValidateCommand()
		{
		
		}
		override public function execute(note:INotification):void
		{
			try
			{
				var vArr:Array=note.getBody() as Array;
				for each (var vVO:ValidateVO in vArr)
				{
					if(vVO.is_Null)
					{
						if (!onNullValidate(vVO.text))
						{
							sendValidateErrorVO(vArr,vVO,Msg.Msg_1,note.getType());
							vArr=null;
							return;
						}
					}
					if(vVO.is_MaxZero)
					{
						if (!onMaxZeroValidate(int(vVO.text)))
						{
							sendValidateErrorVO(vArr,vVO,Msg.Msg_2,note.getType());
							vArr=null;
							return;
						}						
					}
				}
				clearArray(vArr);
				vArr=null;
				this.sendNotification(VC_VALIDATA_RESULT, null, note.getType());
			}
			catch (er:Error)
			{
				this.sendNotification(ExceptionCommand.EXCEPTION, er.message + "\n" + er.getStackTrace());
			}			
		}
		/**
		 * 发送验证错误对象通知
		 */
		private function sendValidateErrorVO(vArr:Array,vVO:ValidateVO,msg:String,type:String):void
		{
			clearArray(vArr);
			vArr=null;
			this.sendNotification(VC_VALIDATA_RESULT, getValidateErrorVO(vVO,msg),type);
			return;			
		}
		/**
		 * 获得验证错误结果对象
		 * @param vVO
		 * @param result
		 * @return 
		 */
		private function getValidateErrorVO(vVO:ValidateVO,result:String):ValidateErrorVO
		{
			var veVO:ValidateErrorVO=new ValidateErrorVO();
			veVO.vVO=vVO;
			veVO.result=result;
			return veVO;
		}
		/**
		 * 空验证
		 * @param str
		 * @return
		 */
		private function onNullValidate(str:String):Boolean
		{
			var bol:Boolean;
			if (str == null)
				bol=false;
			else if (str == "")
				bol=false;
			else if (str == " ")
				bol=false;
			else
				bol=true;
			return bol;
		}		
		/**
		 * 大于0验证
		 * @param num
		 * @return 
		 */
		private function onMaxZeroValidate(num:int):Boolean
		{
			var bol:Boolean;
			if(num>0)
				bol=true;
			else
				bol=false;
			return bol;	
		}
		/**
		 * 清理验证对象集合
		 * @param arr
		 */
		private function clearArray(arr:Array):void
		{
			if(arr)
				arr.splice(0,arr.length);
			arr=null;	
		}		
	}
}