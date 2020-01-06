import SpriteKit
import GameplayKit
import UIKit
import AVFoundation

var score = 0
var bestScore = 0

struct PC {
    static var ramp: UInt32 = 0b1000000// 3
    static var ball: UInt32 = 0b10 //2
    static var scoreline: UInt32 = 0b100 //4
    static var gameOver: UInt32 = 0b10000 //32
}

var audioPlayer = AVAudioPlayer()

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var counter = 0
    
    var oneBall = true
    
    var yastyopid = 0
    
    var ballGravity = -9.81
    
    let texture = SKTexture(imageNamed: "Bucket")
    let bucket = SKSpriteNode(imageNamed: "Bucket")
    
    //let texture = SKTexture(imageNamed: "scoreLine")
    let scoreLine = SKSpriteNode(imageNamed: "scoreLine")
    
    var location = CGPoint(x: 0, y: 0)
    
    override func didMove(to view: SKView) {
        
        print("didMove(to view: SKView) ")
        
        bucket.zRotation = CGFloat(Double.pi)
        
        physicsWorld.contactDelegate = self
        
        let width = self.size.width
        let height = self.size.height
        
        var splinePoints = [CGPoint(x: 0 , y: height),
                            
                            CGPoint(x: width, y: height)]
        
        let ground = SKShapeNode(splinePoints: &splinePoints,
                                 count: splinePoints.count)
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 0.75
        
        //self.addChild(ground)
        
        spawnBucket()
        makeScoreLine()
        makeramp()
        makeGameOverLine()
        makeBounceLine()
        
        
        
        ground.physicsBody?.categoryBitMask = 0b0001
        
        //playSound(fileName: "Ping Pong Hit")
        //playSound(fileName: "Success6")
        //playSound(fileName: "Failure")
        
        
    }
    
    func playSound(fileName: String) {
        
        let sound = Bundle.main.path(forResource: fileName, ofType: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            audioPlayer.prepareToPlay()
            
            DispatchQueue.global().async {
                audioPlayer.play()
            }
        } catch {
            print("Error in playing sound")
        }
      
    }
    
   
    
    func action() {
        counter += 1
        print(counter)
        
        //gameScene.action()
        //bucket.zRotation = CGFloat(Double.pi/20)
        bucket.zRotation = CGFloat(Double.pi/20)
    }
    
    
    func spawnBucket() {
        
        bucket.zRotation = CGFloat(Double.pi/2)
        bucket.physicsBody = SKPhysicsBody(texture: texture, size: bucket.size)
        
        var width = scene!.size.width
        var height = scene!.size.height
        
        bucket.position = CGPoint(x: width * 0.25, y: -height * 0.30)
        
        //bucket.position = CGPoint(x: scene!.size.width/2 - 150, y: 100.0 - scene!.size.height/2)
        //bucket.position = CGPoint(x: 0, y: 0)
        bucket.setScale(0.4)
        bucket.zRotation = CGFloat(3 * Double.pi/4)
        
        bucket.physicsBody?.affectedByGravity = false
        bucket.physicsBody?.isDynamic = false
        
        bucket.physicsBody?.categoryBitMask = PC.ball
        bucket.physicsBody?.contactTestBitMask = PC.ball
        //bucket.physicsBody?.categoryBitMask = PC.ramp
        bucket.physicsBody?.restitution = 0.50
        
        self.addChild(bucket)
        
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi/1.9), duration: 2.0)
        let rotateback = SKAction.rotate(byAngle: CGFloat(-Double.pi/1.9), duration: 2.0)
        let sequence = SKAction.sequence([rotate, rotateback])
        
        //bucket.run(SKAction.repeatForever(sequence))
        
    }
    
    func makeramp() {
        // var sceneSize:CGSize { get set }
        
        let rampSize: CGSize = CGSize(width: 2000, height: 20)
        let ramp = SKShapeNode(rectOf: rampSize)
        
        ramp.fillColor = .white
        //ramp.position = CGPoint (x: 120 - scene!.size.width/2, y:120 - scene!.size.height/2)
        
        var width = scene!.size.width
        var height = scene!.size.height
        
        ramp.position = CGPoint (x: -width * 0.3, y: -height*0.3)
        //ramp.position = CGPoint (x: 0, y:100)
        ramp.zRotation = CGFloat(-Double.pi/4)
        
        ramp.physicsBody = SKPhysicsBody(rectangleOf: rampSize)
        
        ramp.physicsBody?.isDynamic = false
        ramp.physicsBody?.restitution = 0.8
        ramp.physicsBody?.affectedByGravity = false
        
        self.addChild(ramp)
        
        ramp.physicsBody?.categoryBitMask = PC.ball
        ramp.physicsBody?.collisionBitMask = PC.ball
        ramp.physicsBody?.contactTestBitMask = PC.ball
        
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi/5.3), duration: 10)
        let rotateback = SKAction.rotate(byAngle: CGFloat(-Double.pi/5.3), duration: 10)
        let sequence = SKAction.sequence([rotate, rotateback])
        
        ramp.run(SKAction.repeatForever(sequence))
    }
    
    
    func spawnredball(x: CGFloat, y: CGFloat) {
        audioPlayer.prepareToPlay()
        if oneBall {
            let ballRadius: CGFloat = 10
            let redBall = SKShapeNode(circleOfRadius: ballRadius)
            
            let randRed = CGFloat(Double(Int.random(in: 1...255))/255.0)
            let randGreen = CGFloat(Double(Int.random(in: 1...255))/255.0)
            let randBlue = CGFloat(Double(Int.random(in: 1...255))/255.0)
            
            redBall.fillColor = UIColor(red: randRed, green: randGreen, blue: randBlue, alpha: 1.0)
            redBall.position.x = x
            redBall.position.y = y
            redBall.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
            
            
            self.addChild(redBall)
            redBall.physicsBody!.isDynamic = true
            
            redBall.physicsBody!.categoryBitMask = PC.ball
            redBall.physicsBody!.collisionBitMask = PC.scoreline | PC.gameOver | PC.ramp
            //redBall.physicsBody?.contactTestBitMask = PC.test1
            oneBall = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var touch : UITouch! = event?.allTouches?.first
        
        location = touch.previousLocation(in: self)
        
        let screenSize: CGSize = self.size
        let endPoint: CGPoint = CGPoint(x: screenSize.width, y: screenSize.height)
        
        //location.self.x <= 0
        
        if (location.self.x <= 0) {
            if oneBall {
                let ballRadius: CGFloat = 15
                let redBall = SKShapeNode(circleOfRadius: ballRadius)
                
                let randRed = CGFloat(Double(Int.random(in: 1...255))/255.0)
                let randGreen = CGFloat(Double(Int.random(in: 1...255))/255.0)
                let randBlue = CGFloat(Double(Int.random(in: 1...255))/255.0)
                
                let randColor = UIColor(red: randRed, green: randGreen, blue: randBlue, alpha: 1.0)
                
                redBall.fillColor = randColor
                redBall.strokeColor = randColor
                
                redBall.glowWidth = 0.0
                redBall.position = location
                redBall.physicsBody?.isDynamic = true
                redBall.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
                
                //redBall.physicsBody?.contactTestBitMask = PC.ball
                redBall.physicsBody?.collisionBitMask = PC.scoreline | PC.ball
                redBall.physicsBody?.categoryBitMask = PC.ball
                
                print("In touches began:" + String(ballGravity))
                redBall.physicsBody?.velocity.dy = CGFloat(ballGravity)
                self.addChild(redBall)
                oneBall = false
            }
        }
    }
    
    func repositionBucket() {
        
        let number = Int.random(in: -100 ... 100)
        
        print(number)
        bucket.position = CGPoint(x: scene!.size.width/2 - 150 + CGFloat(number), y: -scene!.size.height/2 + 100 + CGFloat(number))
        //bucket.position = CGPoint(x: 0, y: 0)
        bucket.zRotation = CGFloat(Double.pi/2)
    }
    
    
    
    func makeScoreLine() {
        
        //let rampSize: CGSize = CGSize(width: 15, height: 80)
        let rampSize: CGSize = CGSize(width: 15, height: 80)
        let scoreLine = SKShapeNode(rectOf: rampSize)
        scoreLine.fillColor = .blue
        
        var width = scene!.size.width
        var height = scene!.size.height
        
        //scoreLine.position = CGPoint (x: scene!.size.width/2 - 150, y: -scene!.size.height/2 + 100)
        scoreLine.position = CGPoint (x: width*0.26, y: -height * 0.3)
        
        //scoreLine.position = CGPoint (x: -width * 0.4, y: height*0.4)
        
        scoreLine.physicsBody = SKPhysicsBody(rectangleOf: rampSize)
        scoreLine.physicsBody?.affectedByGravity = false
        scoreLine.physicsBody?.allowsRotation = false
        scoreLine.physicsBody?.isDynamic = false
        scoreLine.isHidden = true
        
        //scoreLine.physicsBody!.isDynamic = true
        scoreLine.physicsBody?.restitution = 0.5
        //scoreLine.physicsBody!.affectedByGravity = true
        
        scoreLine.zRotation = CGFloat(-Double.pi/4)
        scoreLine.zPosition = 1
        
        self.addChild(scoreLine)
        scoreLine.physicsBody!.categoryBitMask = PC.scoreline
        //scoreLine.physicsBody!.collisionBitMask = PC.ball
        scoreLine.physicsBody?.contactTestBitMask = PC.ball
        
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi/1.9), duration: 2.0)
        let rotateback = SKAction.rotate(byAngle: CGFloat(-Double.pi/1.9), duration: 2.0)
        let sequence = SKAction.sequence([rotate, rotateback])
        
        //scoreLine.run(SKAction.repeatForever(sequence))
    }
    
    func makeGameOverLine() {
        // var sceneSize:CGSize { get set }
        
        let lineSize: CGSize = CGSize(width: 10000, height: 20)
        let line = SKShapeNode(rectOf: lineSize)
        line.fillColor = .green
        //line.position = CGPoint (x: 120 - scene!.size.width/2, y: -scene!.size.height/2 - 20)
        
        line.position = CGPoint (x: 0.0, y: -scene!.size.height/2 - 20)
        //ramp.position = CGPoint (x: 0, y:100)
        
        line.physicsBody = SKPhysicsBody(rectangleOf: lineSize)
        
        line.physicsBody?.isDynamic = false
        line.physicsBody?.restitution = 0
        line.physicsBody?.affectedByGravity = false
        
        line.physicsBody!.categoryBitMask = PC.gameOver
        line.physicsBody?.contactTestBitMask = PC.ball
        line.isHidden = true
        
        self.addChild(line)
    }
    
    let lineSize: CGSize = CGSize(width: 20, height: 200)
    let bounceLine = SKShapeNode(rectOf: CGSize(width: 20, height: 200))
    
    func makeBounceLine() {
        // var sceneSize:CGSize { get set }
        
        bounceLine.fillColor = .blue
        bounceLine.strokeColor = .blue
        
        var width = scene!.size.width
        var height = scene!.size.height
        
        bounceLine.position = CGPoint (x: width*0.40, y: 0)
        //bounchLine.position = CGPoint (x: -60 + scene!.size.width/2, y: 0)
        //ramp.position = CGPoint (x: 0, y:100)
        
        bounceLine.physicsBody = SKPhysicsBody(rectangleOf: lineSize)
        
        bounceLine.physicsBody?.isDynamic = false
        bounceLine.physicsBody?.restitution = 0.8
        bounceLine.physicsBody?.affectedByGravity = false
        
        //line.physicsBody!.categoryBitMask = PC.gameOver
        bounceLine.physicsBody?.categoryBitMask = PC.ball
        bounceLine.physicsBody?.contactTestBitMask = PC.ball
        
        bounceLine.isHidden = false
        
        self.addChild(bounceLine)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch : UITouch! = event?.allTouches?.first
        
        location = touch.previousLocation(in: self)
        //let location = touch.location(in: self.view)
        
        var width = scene!.size.width
        var height = scene!.size.height
        
        if(location.x >= 0) {
            bounceLine.position = CGPoint (x: width*0.40, y: location.y)
            //bounchLine.position = CGPoint (x: -60 + scene!.size.width/2, y: location.y)
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision: UInt32 = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask)
        audioPlayer.prepareToPlay()
        
        print("collision occurred")
        
        if (collision == (PC.ball | PC.scoreline)) {
            score += 1
            
            contact.bodyB.node?.removeFromParent()
            
            print("Score: " + String(score))
            oneBall = true;
            
            ballGravity = ballGravity * 1.20
            print(ballGravity)
            
            playSound(fileName: "Success6")
            
            if score > bestScore {
                bestScore = score
                UserDefaults.standard.set(bestScore, forKey: "bestScore")
            }
            
            //repositionBucket()
        } else if (collision == (PC.ball | PC.gameOver)){
            
            if score > bestScore {
                bestScore = score
                UserDefaults.standard.set(bestScore, forKey: "bestScore")
            }
            
            playSound(fileName: "Failure")
            score = 0
            ballGravity = -9.81
            oneBall = true;
            contact.bodyB.node?.removeFromParent()
        } else if(collision == (PC.ball | PC.ball)) {
            
            playSound(fileName: "Ping Pong Hit")
        }
        
        /*
         let bounce: UInt32 = (contact.bodyA.collisionBitMask | contact.bodyB.collisionBitMask)
         
         if (*/
    }
    
    
    
}
