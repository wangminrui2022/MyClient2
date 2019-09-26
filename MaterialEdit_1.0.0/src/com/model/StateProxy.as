package com.model
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * 状态模型层
	 * @author wangmingfan
	 */
	public class StateProxy extends Proxy
	{
		public static const NAME:String="StateProxy";
		
		//编辑状态(编辑中,未编辑)
		public var editState:Boolean;
		//保存状态(保存,未保存)
		[Bindable]
		public var saveState:Boolean;
														
		public function StateProxy(data:Object=null)
		{
			super(NAME, data);
		}
		/**
		 * 当前模型层_垃圾清理
		 */
		public function clear():void
		{
			editState=false;
			saveState=false;	
		}		
	}
}