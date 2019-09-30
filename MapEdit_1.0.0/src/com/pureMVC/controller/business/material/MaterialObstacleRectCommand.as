/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.material
{
	import com.maptype.vo.PointVO;
	import com.maptype.vo.RectangleVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 获得材质的障碍点矩形数组
	 * @author 王明凡
	 */
	public class MaterialObstacleRectCommand extends SimpleCommand
	{
		public static const MORC_MATERIAL_OBSTACLE_RECT:String="morc_material_obstacle_rect";
		
		public static const MORC_MATERIAL_OBSTACLE_RECT_RESULT:String="morc_material_obstacle_rect_result";
		
		public var roadArr:Array;	
		
		public function MaterialObstacleRectCommand()
		{

		}
		override public function execute(note:INotification):void
		{
			var obstaclePointArr:Array=getObstaclePointArr(note.getBody() as Array);
			//如果该材质没有设置障碍点
			if(obstaclePointArr.length==0)
			{
				obstaclePointArr=null;
				this.sendNotification(MORC_MATERIAL_OBSTACLE_RECT_RESULT,null);		
			}
			else
			{
				obstaclePointArr.sort(getX);
				var minX:int=obstaclePointArr[0].x;
				var maxX:int=obstaclePointArr[obstaclePointArr.length-1].x;
				
				obstaclePointArr.sort(getY);
				var minY:int=obstaclePointArr[0].y;
				var maxY:int=obstaclePointArr[obstaclePointArr.length-1].y;	
				
				var width:int=maxX-minX;
				var height:int=maxY-minY;
				
				obstaclePointArr.splice(0,obstaclePointArr.length);
				obstaclePointArr=null;
				this.sendNotification(MORC_MATERIAL_OBSTACLE_RECT_RESULT,new RectangleVO(minX,minY,width,height));
			}		
		}
		/**
		 * 返回当前材质路点集合中障碍点的坐标集合
		 * @param roadArr
		 * @return 
		 */
		private function getObstaclePointArr(roadArr:Array):Array
		{
			var tmp:Array=new Array();
			for(var y:int=0;y<roadArr.length;y++)
			{
				for(var x:int=0;x<roadArr[0].length;x++)
				{
					if(roadArr[y][x].type==1)
						tmp.push(roadArr[y][x].point);
				}
			}
			roadArr=null;
			return tmp;
		}
		/**
		 * X方向排序(从小到大)
		 * @param a
		 * @param b
		 * @return 
		 */
		private function getX(a:PointVO,b:PointVO):int
		{
			if(a.x>b.x)
				return 1;
			else if(a.x<b.x)
				return -1;
			else 
				return 0;
		}
		/**
		 * Y方向排序(从小到大)
		 * @param a
		 * @param b
		 * @return 
		 */
		private function getY(a:PointVO,b:PointVO):int
		{
			if(a.y>b.y)
				return 1;
			else if(a.y<b.y)
				return -1;
			else 
				return 0;
		}		
	}
}