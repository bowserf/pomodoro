# Lessons learned from a beginner

#### UIStackView
- backgroundColor has no effect on a UIStackview because
draw() is never called.
https://useyourloaf.com/blog/stack-view-background-color/
- call addArrangedSubview to add a view
- alignment = .center
- axis = .vertical
- Handle click, call isUserInteractionEnabled = false to enable the parent to trigger click event.
By default, for a UILabel, this variable is set to false.

#### UIImage
- withRenderingMode(.alwaysTemplate). This mode will replace all non-transparent colors on a UIImage with the tint color

#### UIView
- Nothing can be draw outside "rect" in a UIView
We have to put padding to have enough space to draw the shadow
override func draw(_ rect: CGRect) {
    let shadowRect = rect.insetBy(dx: Constants.shadowSize, dy: Constants.shadowSize)
    let path = UIBezierPath(ovalIn: shadowRect)
    let context = UIGraphicsGetCurrentContext()!
    context.setShadow(
        offset: Constants.shadowOffset,
        blur: 5,
        color: Constants.shadowColor.cgColor)
    context.setFillColor(circleColor.cgColor)
    context.addPath(path.cgPath)
    context.fillPath()
}
- layoutSubviews()
Implementation uses any constraints you have set to determine the size and position of any subviews.

#### Animation
- Use variable or function of a class in a closure need explicite use of `self` keyword.
- When using AutoLayout and when to do a translation on a view, use anchor constant to move the view instead of CGAffineTransform.