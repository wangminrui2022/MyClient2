package com.myclient2sample1.pureMVC.model
{
	import com.myclient2.core.engine.MObjects;
	import com.myclient2sample1.vo.MapConvertVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * 地图操作对象模型层
	 * @author 王明凡
	 */
	public class MapOperateProxy extends Proxy
	{
		public static const NAME:String="MapOperateProxy";
		//地图操作对象集合
		public var MapOperateMObjectsArr:Array;
				
		public function MapOperateProxy(data:Object=null)
		{
			super(NAME, data);
		}		
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			if(MapOperateMObjectsArr)
			{
				for each(var oj:MObjects in MapOperateMObjectsArr)
				{
					oj.clear();
					oj=null;
				}
				MapOperateMObjectsArr.splice(0,MapOperateMObjectsArr.length);
			}
			MapOperateMObjectsArr=null;
		}		
	}
}