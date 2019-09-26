/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.vo
{
	/**
	 * 路点对象描述规范
	 * @author 王明凡
	 */
	public class MRoadVO
	{
		/**
		 * 该点对应菱形x索引
		 * @default 
		 */
		public var rhombusX:int;
		/**
		 * 该点对应菱形y索引
		 * @default 
		 */
		public var rhombusY:int;
		/**
		 * 该点数组x索引
		 * @default 
		 */
		public var ix:int;
		/**
		 * 该点数组y索引
		 * @default 
		 */
		public var iy:int;
		/**
		 * F值
		 * @default 
		 */
		public var F:int;
		/**
		 * G值
		 * @default 
		 */
		public var G:int;
		/**
		 * H值
		 * @default 
		 */
		public var H:int;
		/**
		 * 路点类型(0.通过,1.障碍,2.阴影)
		 * @default 
		 */
		public var type:int;
		/**
		 * 父节点
		 * @default 
		 */
		public var father:MRoadVO;
	}
}