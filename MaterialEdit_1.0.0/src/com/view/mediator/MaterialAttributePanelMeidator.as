package com.view.mediator
{
	import com.consts.Msg;
	import com.controller.business.*;
	import com.model.*;
	import com.view.ui.MaterialAttributePanel;
	import com.vo.*;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 材质属性面板
	 * @author 王明凡
	 */
	public class MaterialAttributePanelMeidator extends Mediator
	{
		public static const NAME:String="MaterialAttributePanelMeidator";
		public static const TYPE:String="MaterialAttributePanelMeidator_type";
		//关闭 
		public static const MAPM_CLOSED:String="mapm_closed";
		//添加节点
		public static const MAPM_ADDNODE:String="mapm_addnode";	
		//修改节点
		public static const MAPM_MODIFY:String="mapm_modify";	
			
		//材质swf
		private var mnVO:MaterialNodeVO;
		//修改
		private var mVO:ModifyVO;
		//节点
		private var mdVO:MaterialDefinitionVO;
		//操作方式(添加,修改)
		private var operationType:String;
		
		private var ui:UIComponent;
		
		private var bindableP:BindableProxy;
		
		private var materialP:MaterialProxy;
			
		public function MaterialAttributePanelMeidator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as  MaterialProxy;
			materialAtr.confirmBtn.addEventListener(MouseEvent.CLICK,onConfirm);
			materialAtr.diffuseBtn.addEventListener(MouseEvent.CLICK,onDiffuse);
			materialAtr.savesBtn.addEventListener(MouseEvent.CLICK,onSaves);	
			ui=new UIComponent();
			materialAtr.img.addChild(ui);
		}
		override public function listNotificationInterests():Array
		{
			return [
			MAPM_CLOSED,
			MAPM_ADDNODE,
			MAPM_MODIFY,
			ValidateCommand.VC_VALIDATA_RESULT,
			SaveImageCommand.SIC_SAVE_IMAGE_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{	
			switch(note.getName())
			{
				case MAPM_CLOSED:
					clear();
					break;
				case MAPM_ADDNODE:
					onAddNode(note.getBody() as MaterialNodeVO);
					break;
				case MAPM_MODIFY:
					onModify(note.getBody() as ModifyVO);
					break;
				case ValidateCommand.VC_VALIDATA_RESULT:
					if(note.getType()==TYPE)
						onValidateResult(note.getBody() as ValidateErrorVO);					
					break;
				case SaveImageCommand.SIC_SAVE_IMAGE_COMPLETE:
					if(note.getBody() as Boolean)
						errorAlert(Msg.Msg_8,true,150,15,materialAtr);
					else
						errorAlert(Msg.Msg_9,true,150,15,materialAtr);
					break;
			}
		}
		/**
		 * 添加节点
		 * @param mnVO
		 */
		private function onAddNode(mnVO:MaterialNodeVO):void
		{
			this.mnVO=mnVO;
			bindableP.isEnabledDiffuseBtn=true;		
		}
		/**
		 * 修改节点
		 * @param mVO
		 */
		private function onModify(mVO:ModifyVO):void
		{
			bindableP.isEnabledDiffuseBtn=false;
			operationType="modify";
			this.mVO=mVO;
			this.mdVO=materialP.getMaterialDefinitionVO(mVO.name);
			materialAtr.m_elementType.selectedIndex=materialAtr.getIndex(materialAtr.elementTypeArr,mdVO.elementType);
			materialAtr.m_type.selectedIndex=materialAtr.getIndex(materialAtr.typeArr, mdVO.type);
			materialAtr.m_used.selectedIndex=materialAtr.getIndex(materialAtr.usedArr, mdVO.used);
			materialAtr.m_name.text=mdVO.name;
			materialAtr.m_diffuse.text=mdVO.diffuse;
			materialAtr.m_width.text=mdVO.width;
			materialAtr.m_height.text=mdVO.height;
			//显示图片
			onDispaly(materialP.getMaterialNodeVOClass(mdVO.diffuse));
		}
		/**
		 * 类定义
		 * @param e
		 */
		private function onDiffuse(e:MouseEvent):void
		{
			if (materialAtr.m_diffuse.text != "")
			{
				var tmp:Class;
				try
				{
					tmp=this.mnVO.loaderInfo.applicationDomain.getDefinition(materialAtr.m_diffuse.text) as Class;
				}catch(er:Error)
				{
					errorAlert(Msg.Msg_7,true,150,15,materialAtr);
					clearImage();
					materialAtr.m_width.text="";
					materialAtr.m_height.text="";					
			  		return;				
				}
				onDispaly(tmp);
			}		
		}
		/**
		 * 显示材质图片/影片剪辑
		 * @param tmp
		 */
		private function onDispaly(tmp:Class):void
		{
			var et:String=materialAtr.m_elementType.selectedItem.label;
			clearImage();
			var sVO:SizeVO=new SizeVO();
			sVO.B=materialAtr.img;
			try
			{
				if (et == "BitmapData")
				{
					var btm:Bitmap=new Bitmap(new tmp(null, null) as BitmapData);
					ui.addChild(btm);
					ui.width=btm.width;
					ui.height=btm.height;
					sVO.A=btm;
					materialAtr.m_width.text=btm.width+"";
					materialAtr.m_height.text=btm.height+"";										
				}
				else if (et == "MovieClip")
				{
					var mc:MovieClip=new tmp() as MovieClip;
					ui.addChild(mc);
					ui.width=mc.width;
					ui.height=mc.height;					
					sVO.A=mc;	
					materialAtr.m_width.text=mc.width+"";
					materialAtr.m_height.text=mc.height+"";					
				}			
			}catch(er:Error)
			{
				errorAlert(Msg.Msg_6,true,150,15,materialAtr);
				clearImage();
				materialAtr.m_width.text="";
				materialAtr.m_height.text="";				  	
			  	clearImage();	
			  	return;					
			}	
			//计算显示尺寸
			this.sendNotification(SizeCommand.SIZE,sVO);

			bindableP.isEnabledConfirmBtn=true;
			bindableP.isEnabledSavesBtn=true;
		}
		/**
		 * 单击保存至
		 * @param e
		 */
		private function onSaves(e:MouseEvent):void
		{
			if(ui.numChildren>0)
			{
				var btm:BitmapData=new BitmapData(ui.width,ui.height,true,0);
				btm.draw(ui.getChildAt(0));
				var meOJ:Object={param1:btm,param2:materialAtr.m_diffuse.text};
				this.sendNotification(SaveImageCommand.SIC_SAVE_IMAGE,meOJ);
				meOJ=null;
			}
		}
		/**
		 * 清理图片
		 */
		private function clearImage():void
		{
			if(ui.numChildren>0)
				this.sendNotification(PageClearCommand.PAGECLEAR,ui, "2");
			bindableP.isEnabledConfirmBtn=false;
			bindableP.isEnabledSavesBtn=false;					
		}		
		/**
		 * 确定
		 * @param e
		 */
		private function onConfirm(e:MouseEvent):void
		{
			var vArr:Array=new Array();
			vArr.push(getVlidateVO("元件类名", materialAtr.m_diffuse.text,true,false));
			vArr.push(getVlidateVO("材质名字", materialAtr.m_name.text,true,false));
			this.sendNotification(ValidateCommand.VC_VALIDATA, vArr, TYPE);						
		}	
		/**
		 * 空验证结果
		 * @param nvVO
		 */
		private function onValidateResult(veVO:ValidateErrorVO):void
		{
			if(veVO)
			{
				errorAlert(veVO.result+veVO.vVO.id,true,150,15,materialAtr);
				veVO=null;				
			}
			else
			{						
				if(operationType=="modify")
				{
					if(this.mdVO.name!=materialAtr.m_name.text)
					{
						if(materialP.getMaterialDefinitionVO(materialAtr.m_name.text))
						{
							errorAlert(Msg.Msg_4,true,150,15,materialAtr);
							return;
						}					
					}
					this.mdVO.diffuse=materialAtr.m_diffuse.text;
					this.mdVO.name=materialAtr.m_name.text;
					this.mdVO.elementType=materialAtr.m_elementType.selectedLabel;
					this.mdVO.type=materialAtr.m_type.selectedLabel;
					this.mdVO.used=materialAtr.m_used.selectedLabel;	
					this.mdVO.width=materialAtr.m_width.text;
					this.mdVO.height=materialAtr.m_height.text;		
					//更新XML显示
					this.mVO.xt.addUI(materialP.getMaterialDefinitionString(this.mdVO));	
					this.mVO.xt.m_name=materialAtr.m_name.text;				
				}
				else
				{
					if(materialP.getMaterialDefinitionVO(materialAtr.m_name.text))
					{
						errorAlert(Msg.Msg_4,true,150,15,materialAtr);
						return;
					}
					if(materialAtr.img.numChildren<1)
					{
						errorAlert(Msg.Msg_5,true,150,15,materialAtr);
						return;				
					}	
					var tmp:MaterialDefinitionVO=new MaterialDefinitionVO();
					tmp.diffuse=materialAtr.m_diffuse.text;
					tmp.name=materialAtr.m_name.text;
					tmp.elementType=materialAtr.m_elementType.selectedLabel;
					tmp.type=materialAtr.m_type.selectedLabel;
					tmp.used=materialAtr.m_used.selectedLabel;	
					tmp.width=materialAtr.m_width.text;
					tmp.height=materialAtr.m_height.text;
					materialP.miVO.MaterialDefinitionVOArr.push(tmp);
					this.sendNotification(MaterialEditorMediator.MEM_ADDNODE,tmp);
					tmp=null;											
				}
				//清理垃圾
				clear();
				//发送保存状态
				this.sendNotification(EditStateCommand.ESC_EDITSTATE,true);					
			}
		}
		/**
		 * 垃圾清理
		 */
		private function clear():void
		{
			bindableP.isEnabledConfirmBtn=false;
			bindableP.isEnabledSavesBtn=false;		
			ui=null;	
			mnVO=null;
			mVO=null;
			mdVO=null;
			bindableP=null;
			materialP=null;
			this.sendNotification(PageClearCommand.PAGECLEAR,materialAtr,"1");
			this.facade.removeMediator(NAME);
			PopUpManager.removePopUp(materialAtr);				
		}
		/**
		 * 错误消息提示
		 * @param msg
		 * @param position
		 * @param x
		 * @param y
		 * @param appUI
		 */
		private function errorAlert(msg:String,position:Boolean=false,x:int=0,y:int=0,appUI:UIComponent=null):void
		{
	  		var msgVO:MessageAlert2VO=new MessageAlert2VO();
	  		msgVO.msg=msg;
	  		if(position)
	  		{
	  			msgVO.x=x;
	  			msgVO.y=y;
	  			msgVO.appUI=appUI;
	  		}
	  		this.sendNotification(Message2Command.MESSAGE2,msgVO);		
	  		appUI=null;
	  		msgVO=null;
		}		
		/**
		 * 获得验证对象
		 * @param id
		 * @param text
		 * @return 
		 */
		private function getVlidateVO(id:String, text:String,is_Null:Boolean,is_MaxZero:Boolean):ValidateVO
		{
			var vVO:ValidateVO=new ValidateVO();
			vVO.id=id;
			vVO.text=text;
			vVO.is_Null=is_Null;
			vVO.is_MaxZero=is_MaxZero;
			return vVO;
		}								
		/**
		 * 返回ModifyAttribute对象
		 * @return
		 */
		private function get materialAtr():MaterialAttributePanel
		{
			return this.viewComponent as MaterialAttributePanel;
		}		
	}
}