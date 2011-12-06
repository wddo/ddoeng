package com.ddoeng.pv3d
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		페이퍼 비전에 기본틀이 되는 베이스 클래스
	 * 2. 메소드
	 * - 리스너
	 * 		onEnter()	::: 실시간으로 렌더링할 엔터프레임
	 * - 내부메소드
	 * 
	 * - 외부메소드
	 * 
	 * - 확장메소드
	 *		
	 */
	public class Base3D extends Sprite
	{
		public var viewPort:Viewport3D;			//PV3D 세상과 플래시를 연결해주는 매개체 [Sprite 상속]
		public var scene:Scene3D;				//scene 생성 (최상위) -  플래시의 스테이지와 같은 객체
		public var camera:Camera3D;				//카메라 생성
		public var renderer:BasicRenderEngine;	//랜더링 엔진 - 플래시의 플래시 플레이어 같은 객체
		
		/**
		 * 페이퍼 비전에 기본틀이 되는 베이스 클래스
		 */		
		public function Base3D()
		{
			super();
			
			this.viewPort = new Viewport3D();
			this.addChild( this.viewPort );
			
			this.scene = new Scene3D();
			
			this.camera = new Camera3D();
			
			this.renderer = new BasicRenderEngine();
			//XXX랜더리는 this.startEnter , this.stopEnter 이용하여 ON/OFF하게 수정해야함
			this.addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//리스너/////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function onEnter(e:Event):void
		{
			this.renderer.renderScene(scene, camera, viewPort);
		}
		
	}
}