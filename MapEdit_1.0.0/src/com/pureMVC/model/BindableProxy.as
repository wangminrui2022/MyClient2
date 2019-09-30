/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.model
{
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * 数据绑定模型层
	 * @author 王明凡
	 */
	public class BindableProxy extends Proxy
	{
		public static const NAME:String="BindableProxy";
		
		public static const B_1:String="SP_saveState";
		public static const B_2:String="setMapMenuEnabled";
		public static const B_3:String="switchMenuEnabled";
		
		//是否正在拖动材质状态
		public var SP_IsDragMaterial:Boolean;
		//是否正在设置路点状态
		public var SP_IsSetRoad:Boolean;
		//编辑状态(编辑=true,未编辑=false)
		public var SP_editState:Boolean;
		//保存状态(保存=true,未保存=false)
		[Bindable]
		public var SP_saveState:Boolean;
		
		/******************【快捷键复选框】****************/
		[Bindable]
		public var CheckBox_Maps:Boolean;
		[Bindable]
		public var CheckBox_Grids:Boolean;
		[Bindable]
		public var CheckBox_Roads:Boolean;
		[Bindable]
		public var CheckBox_Objects:Boolean;
		/******************【菜单】**********************/
		//关闭
		[Bindable]
		public var closeMenuEnabled:Boolean;
		//地图信息		
		[Bindable]
		public var mapInfoMenuEnabled:Boolean;	
		//设置地图		
		[Bindable]
		public var setMapMenuEnabled:Boolean;			
		//交换深度		
		[Bindable]
		public var switchMenuEnabled:Boolean;
		//复制地图效果图		
		[Bindable]
		public var copyMapImageMenuEnabled:Boolean;	
			
		public function BindableProxy(data:Object=null)
		{
			super(NAME, data);
		}
		/**
		 * 设置属性为true
		 */
		public function init():void
		{
			SP_editState=true;
			CheckBox_Grids=true;
			CheckBox_Maps=true;
			CheckBox_Objects=true;
			CheckBox_Roads=true;
			closeMenuEnabled=true;
			mapInfoMenuEnabled=true;
			switchMenuEnabled=true;		
			copyMapImageMenuEnabled=true;			
		}
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			SP_IsDragMaterial=false;
			SP_IsSetRoad=false;
			SP_editState=false;
			SP_saveState=false;			
			CheckBox_Maps=false;
			CheckBox_Grids=false;
			CheckBox_Roads=false;
			CheckBox_Objects=false;
			closeMenuEnabled=false;
			mapInfoMenuEnabled=false;
			setMapMenuEnabled=false;
			switchMenuEnabled=false;
			copyMapImageMenuEnabled=false;
		}
	}
}