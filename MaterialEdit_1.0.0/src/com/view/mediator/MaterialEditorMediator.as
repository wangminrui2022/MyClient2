package com.view.mediator
{
	import com.controller.business.*;
	import com.model.*;
	import com.view.ui.*;
	import com.vo.*;
	
	import flash.display.*;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 *
	 * @author wangmingfan
	 */
	public class MaterialEditorMediator extends Mediator
	{
		public static const NAME:String="MaterialEditorMediator";
		public static const TYPE:String="MaterialEditorMediator_Type";
		//添加节点
		public static const MEM_ADDNODE:String="mem_addnode";
		//修改节点
		public static const MEM_OPEN_MODIFY:String="mem_open_modify";
		//删除节点
		public static const MEM_DELETE:String="mem_delete";
				
		private var mnVO:MaterialNodeVO;
		private var materialP:MaterialProxy;
		private var uiP:UIProxy;
		
		public function MaterialEditorMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as  MaterialProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;	
		}
		override public function listNotificationInterests():Array
		{
			return [
			MEM_ADDNODE,
			MEM_OPEN_MODIFY,
			MEM_DELETE,
			MainMediator.MEMM_CLOSE_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case MEM_ADDNODE:
					onAddNode(note.getBody() as MaterialDefinitionVO);
					break;
				case MEM_OPEN_MODIFY:
					onOpenModify(note.getBody());
					break;
				case MEM_DELETE:
					onDelete(note.getBody() as ModifyVO);
					break;
				case MainMediator.MEMM_CLOSE_COMPLETE:
					materialEditor.xmlTextVBox.removeAllChildren();	
					break;
			}
		}
		/**
		 * 添加节点
		 * @param mdVO
		 */
		private function onAddNode(mdVO:MaterialDefinitionVO):void
		{			
			var xt:XmlText=new XmlText();
			xt.str=materialP.getMaterialDefinitionString(mdVO);
			xt.m_name=mdVO.name;
			materialEditor.xmlTextVBox.addChild(xt);
			mdVO=null;
			xt=null;
		}
		/**
		 * 打开修改节点
		 * @param oj
		 */
		private function onOpenModify(oj:Object):void
		{
			var matp:MaterialAttributePanel=MaterialAttributePanel(PopUpManager.createPopUp(uiP.app, MaterialAttributePanel, true));
			PopUpManager.centerPopUp(matp);
			this.facade.registerMediator(new MaterialAttributePanelMeidator(matp));
			this.sendNotification(MaterialAttributePanelMeidator.MAPM_MODIFY,oj);
			matp=null;	
		}
		/**
		 * 删除节点
		 * @param mVO
		 */
		private function onDelete(mVO:ModifyVO):void
		{
			materialP.deleteMaterialDefinitionVO(mVO.name);
			this.sendNotification(PageClearCommand.PAGECLEAR,mVO.xt,"1");
			//发送保存状态
			this.sendNotification(EditStateCommand.ESC_EDITSTATE,true);				
		}		
		/**
		 *
		 * @return
		 */
		private function get materialEditor():MaterialEditor
		{
			return this.viewComponent as MaterialEditor;
		}
	}
}