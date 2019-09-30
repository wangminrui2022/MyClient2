/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.engine
{
	import flash.system.System;
	import flash.utils.Dictionary;

	/**
	 * 对象池(以下简称池) → 对象区(以下简称区) → <对象>
	 * @author 王明凡
	 */
	public class MPool
	{
		private static var pools:Dictionary=new Dictionary();

		public function MPool()
		{

		}

		/**
		 * 从池的区中取出一个当前类型的<对象>
		 * 1.检查池中是否有当前类型的区,如果没有就申请一个当前类型的区
		 * 2.取出当前类型的<对象>的区
		 * 3.如果区中已经没有当前类型的<对象>了,那么就向区中添加一个当前类型的<对象>
		 * 4.从区中取出这个类型的<对象>
		 * @param cls
		 * @return
		 */
		public static function CheckOut(cls:Class):Object
		{
			if (!MPool.pools[cls])
				MPool.pools[cls]=new Array();
			var clsArr:Array=MPool.pools[cls];
			if (clsArr.length == 0)
				clsArr.push(new cls());
			cls=null;
			return clsArr.pop();
		}

		/**
		 * 将<对象>放回池的区中
		 * 1.<对象>是否为null
		 * 2.对类<对象>或给定<对象>实例的构造函数的引用
		 * 3.检查池中是否有当前类型的区,如果没有就申请一个当前类型的区
		 * 4.取出当前类型的<对象>的区
		 * 5.将<对象>放回区中
		 * @param oj
		 */
		public static function CheckIn(oj:Object):void
		{
			if (!oj)
				return;
			var cls:Class=oj.constructor;
			if (!MPool.pools[cls])
				MPool.pools[cls]=new Array();
			var clsArr:Array=MPool.pools[cls];
			clsArr.push(oj);
			oj=null;
			clsArr=null;
		}

		/**
		 * 释放某个<对象>或全部<对象>区所占的内存
		 * @param cls
		 * @param isGC
		 */
		public static function removes(cls:Class=null, isGC:Boolean=false):void
		{

			if (cls)
			{
				delete MPool.pools[cls];
			}
			else
			{
				for each(var i:*in MPool.pools)
					delete MPool.pools[i];
			}
			if (isGC)
				System.gc();
			cls=null;
		}
	}
}