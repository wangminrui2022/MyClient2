/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.interfaces
{
	import flash.geom.Rectangle;
	/**
	 * IQuadtree接口定义了用于操作(创建，查询，删除)四叉树数据结构
	 * @author 王明凡
	 */	
	public interface IQuadtree
	{
		/**
		 * 根据传入的"根节点"创建当前"根节点"以下的四叉树数据结构节点
		 * @param iNode	  	根节点
		 */		
		function createQuadtree(iNode:IQuadtreeNode):void;
		/**
		 * 根据传入的"根节点"查询当前"根节点"以下的四叉树数据结构节点
		 * @param iNode		根节点
		 * @param rectangle 矩形框(查询范围)
		 */		
		function selectQuadtree(iNode:IQuadtreeNode,rect:Rectangle):void;
		/**
		 * 根据传入的"根节点"清理当前"根节点"以下的四叉树数据结构节点
		 * @param iNode		根节点
		 */		
		function deleteQuadtree(iNode:IQuadtreeNode):void;
		/**
		 * 垃圾清理
		 */		
		function clear():void;
	}
}