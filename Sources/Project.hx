package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import LevelData;

using kha.graphics2.GraphicsExtension;

class Project {
	var rocketPosition:kha.math.FastVector2;
	var rocketSize:kha.math.FastVector2;
		
	var ballPosition:kha.math.FastVector2;
	var ballRadius:Int = 10;
	var ballVelocity:kha.math.FastVector2;
	var mouse:kha.math.FastVector2;
	var font:kha.Font;
	
	var difficalty = 1;
	var score = 0;
	var balls = 0;
	var blocks:Array<Block> = [];
	var fallingBlocks:Array<Block> = [];
	var gameOver = false;
	var ballSticked = false;
	
	
	public function new() {
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	
		mouse = new kha.math.FastVector2(0,0);
		kha.input.Mouse.get().notify(onMouseDown, null, onMouseMove, null);
		initLevel();
	}
	
	function initLevel()
	{
		var data = LevelData.get(1);
		blocks = data.blocks;
		gameOver = false;
		
		ballPosition = new kha.math.FastVector2(System.windowWidth() / 2,200);
		ballVelocity = new kha.math.FastVector2(0,2 * difficalty);
		ballSticked  = true;
	
		rocketPosition = new kha.math.FastVector2(0,0);
		rocketSize = new kha.math.FastVector2(100, 10);
	}
	
	function onMouseMove(x,y, ox, oy)
	{
		mouse.x = x;
		mouse.y = y;
	}
	
	function onMouseDown(x,y,_)
	{
		ballSticked = false;
	}

	function update(): Void {
		if (gameOver)
		{
			return;
		}
		
		//physics
		rocketPosition.x = mouse.x;
		rocketPosition.y = System.windowHeight() - 100;
		if (ballSticked)
		{
			ballPosition.x = rocketPosition.x + rocketSize.x / 2;
			ballPosition.y = rocketPosition.y - ballRadius;
		}
		else
		{
			ballPosition = ballPosition.add( ballVelocity );
		}
		for (b in fallingBlocks)
			b.y += 2;
		
		
		
		//collision check
		
		if ((rocketPosition.x < ballPosition.x) && 
		   (rocketPosition.x + rocketSize.x > ballPosition.x) &&
		   (rocketPosition.y < ballPosition.y + ballRadius) &&
		   (rocketPosition.y + rocketSize.y > ballPosition.y - ballRadius))
		{
			ballVelocity.x = -(rocketPosition.x + rocketSize.x / 2 - ballPosition.x) * 2  / rocketSize.x;
			ballVelocity.y = -ballVelocity.y;
		}
		else if ((ballPosition.x - ballRadius <= 0) || 
				 (ballPosition.x + ballRadius >= System.windowWidth()))
		{
			ballVelocity.x = -ballVelocity.x;
		}	
		else if (ballPosition.y - ballRadius <= 0)
		{
			ballVelocity.y = -ballVelocity.y;
		}
		else
		{
			for (b in blocks.copy())
				if ((ballPosition.x > b.x) && 
				    (ballPosition.x < b.x + LevelData.blockWidth) &&
					(ballPosition.y > b.y) &&
					(ballPosition.y < b.y + LevelData.blockHeight))
				{
					blocks.remove(b);
					fallingBlocks.push( b );
					ballVelocity.x *= -1.05;
					ballVelocity.y *= -1.05;
				}		
		}
			
		
	}

	function render(framebuffer: Framebuffer): Void {
		var g2 = framebuffer.g2;
		g2.begin();
		
		g2.color = kha.Color.Blue;
		
		g2.drawRect(rocketPosition.x, rocketPosition.y, rocketSize.x, rocketSize.y);
		g2.fillCircle( ballPosition.x, ballPosition.y, ballRadius);
		
		for (b in blocks)
			g2.fillRect( b.x, b.y, LevelData.blockWidth, LevelData.blockHeight);
			
		g2.color = kha.Color.Red;
		for (b in fallingBlocks)
			g2.fillRect( b.x, b.y, LevelData.blockWidth, LevelData.blockHeight);
		
		g2.color = kha.Color.White;
		//g2.font  = font;
//		g2.drawString('Score: $score', 20, 20);
//		g2.drawString('Ball: $balls', System.windowWidth() - 50, 20);
		
		g2.end();		
	}
}
