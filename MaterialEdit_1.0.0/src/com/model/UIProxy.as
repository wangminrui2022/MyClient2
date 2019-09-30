package com.model
{
	import com.view.ui.MaterialEditor;
	import com.view.ui.MaterialPanel;
	
	import mx.containers.Canvas;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * 当前显示UI模型层
	 * @author 王明凡
	 */
	public class UIProxy extends Proxy
	{
		
		public static const NAME:String="UIProxy";
		
		public function UIProxy(data:Object=null)
		{
			super(NAME, data);
		}
		/**
		 * 主容器
		 * @return 
		 */
		public function get app():MaterialEdit
		{
			return this.data as MaterialEdit;
		}
		
		/**
		 * 业务容器
		 * @return 
		 */
		public function get operatePanel():Canvas
		{
			return app.operatePanel;
		}		
		/**
		 * 材质面板
		 * @return 
		 */
		public function get materialPanel():MaterialPanel
		{
			return app.materialPanel;
		}
		/**
		 * 材质编辑面板
		 * @return 
		 */
		public function get materialEditor():MaterialEditor
		{
			return app.materialEditor;
		}				
	}
}