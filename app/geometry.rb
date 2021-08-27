# Adapted from https://github.com/DSchaedler/dyn_light/blob/main/app/geometry.rb
# Original author: D Schaedler (https://github.com/DSchaedler)
# MIT License
# Copyright (c) 2021 D Schaedler

DEG_TO_RAD = Math::PI / 180

# Provides geometry functions "missing" from args.geometry
module RayGeometry
  attr_gtk

  def find_point(point:, distance:, angle:)
    x = point[:x] + distance * Math.cos(angle * DEG_TO_RAD)
    y = point[:y] + distance * Math.sin(angle * DEG_TO_RAD)
    { x: x, y: y }
  end

  def slope(line:)
    return nil if line[:x] == line[:x2]
    (line[:y] - line[:y2]).fdiv(line[:x] - line[:x2])
  end

  def y_intercept(line:)
    slope = RayGeometry.slope(line: line)
    if slope.nil?
      nil
    else
      # b = y - (m * x)
      line[:y] - slope * line[:x]
    end
  end

  def x_intercept(line:)
    slope = RayGeometry.slope(line)
    if slope.nil? || slope.zero?
      nil
    else
      # x = (y - b) / m
      b = RayGeometry.y_intercept(slope: slope, line: line)
      (line[:y] - b) / slope
    end
  end

  def intersect(line1:, line2:)
    slope_line1 = RayGeometry.slope(line: line1)
    y_intercept1 = RayGeometry.y_intercept(line: line1)

    slope_line2 = RayGeometry.slope(line: line2)
    y_intercept2 = RayGeometry.y_intercept(line: line2)

    return nil unless slope_line1 != slope_line2

    if slope_line1.nil?
      x = line1[:x]
      y = slope_line2 * x + y_intercept2
    elsif slope_line2.nil?
      x = line2[:x]
      y = slope_line1 * x + y_intercept1
    else
      x = (y_intercept2 - y_intercept1).fdiv(slope_line1 - slope_line2)
      y = slope_line1 * x + y_intercept1
    end

    { x: x, y: y }
  end

  # TODO
  def segment_intersect(line1:, line2:)
    intersection = RayGeometry.intersect(line1: line1, line2: line2)

    intersect_box = intersection.merge(w: 1, h: 1)

    line1_box = $gtk.args.geometry.line_rect(line1)
    line2_box = $gtk.args.geometry.line_rect(line2)

    line1_box[:w] = 1 if line1_box[:w] == 0
    line1_box[:h] = 1 if line1_box[:h] == 0

    line2_box[:w] = 1 if line2_box[:w] == 0
    line2_box[:h] = 1 if line2_box[:h] == 0


    check_line1 = $gtk.args.geometry.intersect_rect?(intersect_box, line1_box)
    check_line2 = $gtk.args.geometry.intersect_rect?(intersect_box, line2_box)

    return intersection if check_line1 && check_line2
  end

  def rect_lines(rect:)
    [
      { x: rect[:x], y: rect[:y], x2: rect[:x] + rect[:w], y2: rect[:y] },
      { x: rect[:x], y: rect[:y], x2: rect[:x], y2: rect[:y] + rect[:h] },
      { x: rect[:x] + rect[:w], y: rect[:y] + rect[:h], x2: rect[:x], y2: rect[:y] + rect[:h] },
      { x: rect[:x] + rect[:w], y: rect[:y] + rect[:h], x2: rect[:x] + rect[:w], y2: rect[:y] }
    ]
  end

  def rect_points(rect:)
    [
      { x: rect[:x], y: rect[:y] },
      { x: rect[:x], y: rect[:y] + rect[:h] },
      { x: rect[:x] + rect[:w], y: rect[:y] },
      { x: rect[:x] + rect[:w], y: rect[:y] + rect[:h] }
    ]
  end
end

RayGeometry.extend RayGeometry