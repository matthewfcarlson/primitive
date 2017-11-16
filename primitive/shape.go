package primitive

import "github.com/fogleman/gg"

type ShapeDef struct {
	ShType ShapeType
	Verticies [][]int

}

type Shape interface {
	Rasterize() []Scanline
	Copy() Shape
	Mutate()
	Draw(dc *gg.Context, scale float64)
	Distance(Shape) float64
	SVG(attrs string) string
	Definition() ShapeDef //returns the definition of the shape
}

type ShapeType int

const (
	ShapeTypeAny ShapeType = iota
	ShapeTypeTriangle
	ShapeTypeRectangle
	ShapeTypeEllipse
	ShapeTypeCircle
	ShapeTypeRotatedRectangle
	ShapeTypeQuadratic
	ShapeTypeRotatedEllipse
	ShapeTypePolygon
)
