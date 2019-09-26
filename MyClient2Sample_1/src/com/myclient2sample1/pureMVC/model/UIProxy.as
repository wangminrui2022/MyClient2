package com.myclient2sample1.pureMVC.model
{
	import com.myclient2sample1.vo.MapConvertVO;
	
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class UIProxy extends Proxy
	{
		public static const NAME:String="UIProxy"; 
		//地图引擎显示容器(No.1)
		public var engineContainer:UIComponent;	
		//地图操作对象显示容器(No.2)
		public var mapOperateContainer:UIComponent;
		//地图角色显示容器(No.3)
		public var roleConatainer:UIComponent;
		//地图组件显示容器(No.4)
		public var componetContainer:UIComponent;
		//地图切换对象集合(地图切换规则集合)
		public var mapConvertVOArr:Array;	
				
		public function UIProxy(data:Object=null)
		{
			super(NAME, data);
		}
		/**
		 * 主容器 MyClient2Sample_1.mxml
		 * @return 
		 */
		public function get app():MyClient2Sample_1
		{
			return this.data as MyClient2Sample_1;
		}		
		/**
		 * 搜索地图切换对象集合里当前地图的切换信息
		 * @param mapName
		 * @param id
		 * @return 
		 */
		public function getMapConvertVO(mapName:String,id:String):MapConvertVO
		{
			for each(var mcVO:MapConvertVO in mapConvertVOArr)
			{
				if(mcVO.mapName==mapName && mcVO.id==id)
				{
					return mcVO;
				}
			}
			return null;
		}	
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			if(mapOperateContainer.numChildren>0)
			{
				var len:int=mapOperateContainer.numChildren;
				for(var i:int=0;i<len;i++)
					mapOperateContainer.removeChildAt(0);
			}	
		}				
	}
}