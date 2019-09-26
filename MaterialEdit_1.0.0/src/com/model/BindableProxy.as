package com.model
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	/**
	 * 数据绑定模型层
	 * @author wangmingfan
	 */
	public class BindableProxy extends Proxy
	{
		public static const NAME:String="BindableProxy";
		
		//菜单可用否		
		[Bindable]
		public var menuEnabled:Boolean = false; 	
		//是否启用类定义按钮
		[Bindable]
		public var isEnabledDiffuseBtn:Boolean=false;		
		//是否启用保存至按钮
		[Bindable]
		public var isEnabledSavesBtn:Boolean=false;	
		//是否启用确定按钮
		[Bindable]
		public var isEnabledConfirmBtn:Boolean=false;	
										
		public function BindableProxy(data:Object=null)
		{
			super(NAME, data);
		}

		/**
		 * 当前模型层_垃圾清理
		 */
		public function clear():void
		{
			menuEnabled=false;	
			isEnabledDiffuseBtn=false;		
		}
		
	}
}