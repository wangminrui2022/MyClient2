/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.quadtree
{
	import flash.geom.Rectangle;

	import com.myclient2.interfaces.*;

	/**
	 * MQuadtree用于操作(创建，查询，删除)四叉树数据结构
	 * @author 王明凡
	 */
	public class MQuadtree implements IQuadtree
	{
		private var gridW:int;
		private var gridH:int;
		private var createComplete:Function;
		private var searchComplete:Function;
		private var serachResult:Array;

		/**
		 * 构造函数
		 * @param gridW
		 * @param gridH
		 * @param createComplete
		 * @param searchComplete
		 */
		public function MQuadtree(gridW:int, gridH:int, createComplete:Function, searchComplete:Function)
		{
			this.gridW=gridW;
			this.gridH=gridH;
			this.createComplete=createComplete;
			this.searchComplete=searchComplete;
			this.serachResult=new Array();
		}
		/**
		 * 根据传入的"根节点"创建当前"根节点"以下的四叉树数据结构节点
		 * @param iNode	  	根节点
		 */	
		public function createQuadtree(iNode:IQuadtreeNode):void
		{
			var node:MQuadtreeNode=iNode as MQuadtreeNode;
			var type:int=getType(node.level, node.width, node.height);
			//如果是叶节点
			if (type == 3)
			{
				//设置当前节点类型
				node.type=type;
				createQuadtree(node.parent);
			}
			else
			{
				//设置当前节点类型
				node.type=type;
				//当前节点宽,高	
				var nodeWidth:int=node.width >> 1;
				var nodeHeight:int=node.height >> 1;
				if (!node.leftTopFlag)
				{
					node.leftTopFlag=true;
					node.leftTop=getQuadtreeNode(node.level + 1, node.x, node.y, nodeWidth, nodeHeight, node);
					createQuadtree(node.leftTop);
				}
				else if (!node.leftBottomFlag)
				{
					node.leftBottomFlag=true;
					node.leftBottom=getQuadtreeNode(node.level + 1, node.x, node.y + (node.height >> 1), nodeWidth, nodeHeight, node);
					createQuadtree(node.leftBottom);
				}
				else if (!node.rightTopFlag)
				{
					node.rightTopFlag=true;
					node.rightTop=getQuadtreeNode(node.level + 1, node.x + (node.width >> 1), node.y, nodeWidth, nodeHeight, node);
					createQuadtree(node.rightTop);
				}
				else if (!node.rightBottomFlag)
				{
					node.rightBottomFlag=true;
					node.rightBottom=getQuadtreeNode(node.level + 1, node.x + (node.width >> 1), node.y + (node.height >> 1), nodeWidth, nodeHeight, node);
					createQuadtree(node.rightBottom);
				}
				else
				{
					if (node.level == 1)
						//全部划分完毕
						createComplete();
					else
						//当前划分完毕  
						createQuadtree(node.parent);
				}
			}
		}
		/**
		 * 根据传入的"根节点"查询当前"根节点"以下的四叉树数据结构节点
		 * @param iNode		根节点
		 * @param rectangle 矩形框(查询范围)
		 */
		public function selectQuadtree(iNode:IQuadtreeNode, rect:Rectangle):void
		{
			var node:MQuadtreeNode=iNode as MQuadtreeNode;
			//如果是叶节点
			if (node.type == 3)
			{
				selectQuadtree(node.parent, rect);
			}
			else
			{
				if (node.leftTopFlag)
				{
					node.leftTopFlag=false;
					//如果矩形框与右节点矩形框相交
					if (!node.leftTop.rectangle.intersection(rect).isEmpty())
					{
						//搜索结果
						setSearchResult(node.leftTop.center, rect);
						//继续子节点
						selectQuadtree(node.leftTop, rect);
					}
					else
					{
						//继续子节点
						selectQuadtree(node, rect);
					}
				}
				else if (node.leftBottomFlag)
				{
					node.leftBottomFlag=false;
					if (!node.leftBottom.rectangle.intersection(rect).isEmpty())
					{
						setSearchResult(node.leftBottom.center, rect);
						selectQuadtree(node.leftBottom, rect);
					}
					else
					{
						selectQuadtree(node, rect);
					}
				}
				else if (node.rightTopFlag)
				{
					node.rightTopFlag=false;
					if (!node.rightTop.rectangle.intersection(rect).isEmpty())
					{
						setSearchResult(node.rightTop.center, rect);
						selectQuadtree(node.rightTop, rect);
					}
					else
					{
						selectQuadtree(node, rect);
					}
				}
				else if (node.rightBottomFlag)
				{
					node.rightBottomFlag=false;
					if (!node.rightBottom.rectangle.intersection(rect).isEmpty())
					{
						setSearchResult(node.rightBottom.center, rect);
						selectQuadtree(node.rightBottom, rect);
					}
					else
					{
						selectQuadtree(node, rect);
					}
				}
				else
				{
					node.leftTopFlag=true;
					node.leftBottomFlag=true;
					node.rightTopFlag=true;
					node.rightBottomFlag=true;
					//如果该节点有根节点
					if (node.parent)
					{
						selectQuadtree(node.parent, rect);
					}
					else
					{
						//显示根节点里的显示对象
						setSearchResult(node.center, rect);
						searchComplete(serachResult);
					}
				}
			}
		}
		/**
		 * 根据传入的"根节点"清理当前"根节点"以下的四叉树数据结构节点
		 * @param iNode		根节点
		 */
		public function deleteQuadtree(iNode:IQuadtreeNode):void
		{
			var node:MQuadtreeNode=iNode as MQuadtreeNode;
			if (node.type == 3)
			{
				clearNode(node);
				deleteQuadtree(node.parent);
			}
			else
			{
				if (node.leftTopFlag)
				{
					node.leftTopFlag=false;
					deleteQuadtree(node.leftTop);
				}
				else if (node.leftBottomFlag)
				{
					node.leftBottomFlag=false;
					deleteQuadtree(node.leftBottom);
				}
				else if (node.rightTopFlag)
				{
					node.rightTopFlag=false;
					deleteQuadtree(node.rightTop);
				}
				else if (node.rightBottomFlag)
				{
					node.rightBottomFlag=false;
					deleteQuadtree(node.rightBottom);
				}
				else
				{
					clearNode(node);
					node.leftTop=null;
					node.leftBottom=null;
					node.rightTop=null;
					node.rightBottom=null;
					//如果该节点有根节点
					if (node.parent)
						deleteQuadtree(node.parent);
				}
			}
		}
		/**
		 * 清理节点垃圾
		 * @param node
		 */
		private function clearNode(node:MQuadtreeNode):void
		{
			if (node.center)
				node.center.splice(0, node.center.length)
			node.center=null;
			node.rectangle=null;
			node=null;
		}

		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			serachResult.splice(0, serachResult.length);
			serachResult=null;
		}
		/**
		 * 返回节点类型
		 * 1.根节点(有四个子节点,无父节点)
		 * 2.子节点(有四个子节点,有一个父节点)
		 * 3.叶节点(无子节点,有一个父节点)
		 * @param nodeLevel		当前节点级别
		 * @param nodeWidth		当前节点宽
		 * @param nodeHeight	当前节点高
		 * @return
		 */
		private function getType(nodeLevel:int, nodeWidth:int, nodeHeight:int):int
		{
			if (nodeLevel == 1)
				return 1;
			else if (nodeWidth >> 1 >= gridW && nodeHeight >> 1 >= gridH)
				return 2;
			else
				return 3;
		}

		/**
		 * 返回四叉树节点
		 * @param level
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parentNode
		 * @return
		 */
		private function getQuadtreeNode(level:int, x:int, y:int, width:int, height:int, parentNode:MQuadtreeNode):MQuadtreeNode
		{
			var center:Array=getCenter(new Rectangle(x, y, width, height), parentNode.center);
			var node:MQuadtreeNode=new MQuadtreeNode(level, x, y, width, height, center, parentNode);
			parentNode=null;
			return node;
		}

		/**
		 * 如果当前子节点完全包含了父节点区域某个显示对象,则划分到子节点
		 *
		 * @param childRectangle	即将要划分子节点的矩形区域
		 * @param parentCenter		父节点区域显示对象集合
		 * @return 					划分了包含对象
		 */
		private function getCenter(childRectangle:Rectangle, parentCenter:Array):Array
		{
			var tmp:Array=new Array();
			//如果父对象没有包含有显示对象
			if (!parentCenter)
				return null;
			var len:int=parentCenter.length;
			for (var i:int=0; i < len; i++)
			{
				var ic:IRectangle=parentCenter[i] as IRectangle;
				//如果子节点的矩形区域完全包含了父节点区域的某个显示对象
				if (childRectangle.containsRect(ic.getRectangle()))
				{
					tmp.push(ic);
					parentCenter.splice(i, 1);
					i-=1;
					len-=1;
				}
			}
			if (tmp.length == 0)
			{
				childRectangle=null;
				parentCenter=null;
				tmp=null;
				return null;
			}
			else
			{
				childRectangle=null;
				parentCenter=null;
				return tmp;
			}
		}

		/**
		 * 如果矩形框和当前节点矩形框相交,设置返回结果
		 * @param center
		 * @param rect
		 */
		private function setSearchResult(center:Array, rect:Rectangle):void
		{
			for each (var ic:IRectangle in center)
			{
				//如果当前显示对象矩形框与矩形框相交
				if (!ic.getRectangle().intersection(rect).isEmpty())
				{
					serachResult.push(ic);
				}
				ic=null;
			}
			center=null;
			rect=null;
		}
	}
}