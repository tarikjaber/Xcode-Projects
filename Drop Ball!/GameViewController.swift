import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    
    
    var counter: Int = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel!.text = "0"
        
        print("View did load loaded")
        
        updateScoreLabel(score: 0)
        
        
        if let view = self.view as! SKView? {
             print("if let view = self.view as! SKView?")
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                
                print("if let scene = SKScene(fileNamed: GameScene)")
                
                scene.scaleMode = .aspectFill
                
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
        
        let timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireTimer() {
        scoreLabel!.text = String(score)
        bestScoreLabel!.text = String(bestScore)
    }
    
    func getScoreLabel() -> UILabel {
        return scoreLabel
    }
    /*
     func getScoreLabel() -> UILabel
     {
     return self.scoreLabel!
     }
     */
    func updateScoreLabel(score: Int) {
        counter = score
        print(counter)
        
        //scoreLabel!.text = String(counter)
        
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    @objc func action() {
        
        //gameScene.action()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision: UInt32 = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask)
        
        if (collision == (PC.ball | PC.scoreline)) {
            
            counter += 1
            
            contact.bodyB.node?.removeFromParent()
            
            //updateScoreLabel(score: score)
            
        }
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        counter += 1
        //print(counter)
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //scoreLabel.text = "Touches Moved"
        
    
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //scoreLabel!.text = String(score)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        scoreLabel.text = "LeBron James"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "bestScore") as? Int{
            bestScore = x
        }
    }
    
    
}
