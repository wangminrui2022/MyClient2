/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.quadtree
{
	import flash.geom.Rectangle;
	
	import com.myclient2.interfaces.IQuadtreeNode;

	/**
	 * MQuadtreeNode是四叉树每个节点对象，描述一个四叉树节点对象信息，位置，范围等
	 * @author 王明凡
	 */	
	public class MQuadtreeNode implements IQuadtreeNode
	{
		/**
		 * 节点级别,表示该节点迭代次数
		 * @default
		 */
		public var level:int;
		/**
		 * 节点类型,通常为：
		 * 根节点(有四个子节点,无父节点)
		 * 子节点(有四个子节点,有一个父节点)
		 * 叶节点(无子节点,有一个父节点)
		 * @default
		 */
		public var type:int;
		/**
		 * 节点起点x
		 * @default
		 */
		public var x:int;
		/**
		 * 节点起点y
		 * @default
		 */
		public var y:int;
		/**
		 * 节点宽
		 * @default
		 */
		public var width:int;
		/**
		 * 节点高
		 * @default
		 */
		public var height:int;
		/**
		 * 父节点
		 * @default
		 */
		public var parent:MQuadtreeNode;
		/**
		 * 左上子节点
		 * @default
		 */
		public var leftTop:MQuadtreeNode;
		/**
		 * 左下子节点
		 * @default
		 */
		public var leftBottom:MQuadtreeNode;
		/**
		 * 右上子节点
		 * @default
		 */
		public var rightTop:MQuadtreeNode;
		/**
		 * 右下子节点
		 * @default
		 */
		public var rightBottom:MQuadtreeNode;

		/**
		 * 左上子节点标志,主要用于：
		 * 是否已经创建该节点
		 * 是否已经搜索该节点
		 * @default
		 */
		public var leftTopFlag:Boolean;

		/**
		 * 左下子节点标志,主要用于：
		 * 是否已经创建该节点
		 * 是否已经搜索该节点
		 * @default
		 */
		public var leftBottomFlag:Boolean;

		/**
		 * 右上子节点标志,主要用于：
		 * 是否已经创建该节点
		 * 是否已经搜索该节点
		 * @default
		 */
		public var rightTopFlag:Boolean;

		/**
		 * 右下子节点标志,主要用于：
		 * 是否已经创建该节点
		 * 是否已经搜索该节点
		 * @default
		 */
		public var rightBottomFlag:Boolean;

		/**
		 * 该节点所包含的矩形区域
		 * @default
		 */
		public var rectangle:Rectangle;

		/**
		 * 该节点包含的图形对象集合(ICenter)
		 * 所包含必须满足两个条件：最小区域,完全包含
		 * @default
		 */
		public var center:Array;
				
		/**
		 * 构造函数
		 * @param level
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param center
		 * @param parent
		 */
		public function MQuadtreeNode(level:int, x:int, y:int, width:int, height:int, center:Array, parent:MQuadtreeNode=null)
		{
			this.level=level;
			this.x=x;
			this.y=y;
			this.width=width;
			this.height=height;
			this.center=center;
			this.parent=parent;
			rectangle=new Rectangle(this.x, this.y, this.width, this.height);			
		}

	}
}