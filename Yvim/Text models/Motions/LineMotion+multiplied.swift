import Foundation

struct LineMotionMultiplied: LineMotion {
    let motion: LineMotion
    let multiplier: Int

    func move(_ position: inout TextPosition) {
        for _ in 0 ..< multiplier {
            motion.move(&position)
        }
    }
}

extension LineMotion {
    func multiplied(_ multiplier: Int) -> LineMotion {
        LineMotionMultiplied(motion: self, multiplier: multiplier)
    }
}
