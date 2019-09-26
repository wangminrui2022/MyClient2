package com.controller.business
{
	import com.model.*;
	import com.view.ui.XmlText;
	import com.vo.*;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 初始化数据
	 * @author wangmingfan
	 */
	public class InitDataCommand extends SimpleCommand
	{
		//初始化数据(通知)
		public static const INIT_DATA:String="init_data";
		//UI层
		private var uiP:UIProxy;
		//材质模型层
		private var materialP:MaterialProxy;
		// 数据绑定模型层
		private var bindableP:BindableProxy;
		//
		private var stateP:StateProxy;
				
		public function InitDataCommand()
		{
			super();
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			stateP=this.facade.retrieveProxy(StateProxy.NAME) as StateProxy;
		}
		override public function execute(note:INotification):void
		{
			//初始化数据类型(1.新建,2.打开)
			if(note.getType()=="1")
			{
				//MaterialProxy 初始化数据(新建完成)
				materialP.miVO=note.getBody() as MaterialInfoVO;
				materialP.miVO.MaterialDefinitionVOArr=new Array();
				materialP.materialNodeVOArr=new Array()	
				//发送保存状态
				this.sendNotification(EditStateCommand.ESC_EDITSTATE,true);		
				//序列化节点集合
				this.sendNotification(SerializableCommand.SERIALIZABLE,null,"1");												
			}
			else
			{
				materialP.miVO.MaterialDefinitionVOArr=new Array();
				setMaterialDefinitionVOArr();	
				displayMaterialDefinitionVOArr();	
				//发送保存状态
				this.sendNotification(EditStateCommand.ESC_EDITSTATE,false);			
			}
			//菜单启用
			bindableP.menuEnabled=true;		
			//编辑状态
			stateP.editState=true;
		}
		/**
		 * 设置材质节点对象集合
		 */
		private function setMaterialDefinitionVOArr():void
		{
			for each(var xml:XML in materialP.miVO.materialXML.materialDefinition)
			{
				var mdVO:MaterialDefinitionVO=new MaterialDefinitionVO();
				mdVO.name=xml.@name
				mdVO.type=xml.@type;
				mdVO.used=xml.@used;
				mdVO.width=xml.@width;
				mdVO.height=xml.@height;
				mdVO.elementType=xml.@elementType;
				mdVO.diffuse=xml.diffuse;
				materialP.miVO.MaterialDefinitionVOArr.push(mdVO);				
			}
		}
		/**
		 * 显示材质节点对象集合
		 */
		private function displayMaterialDefinitionVOArr():void
		{
			for each(var mdVO:MaterialDefinitionVO in materialP.miVO.MaterialDefinitionVOArr)
			{
				var xt:XmlText=new XmlText();
				xt.str=materialP.getMaterialDefinitionString(mdVO);
				xt.m_name=mdVO.name;
				uiP.materialEditor.xmlTextVBox.addChild(xt);
				mdVO=null;
				xt=null;			
			}
		}
	}
}