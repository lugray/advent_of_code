def simplify_oposite(steps)
  [['ne', 'sw'], ['n', 's'], ['nw', 'se']].each do |forward, backward|
    cancelling = [steps[forward], steps[backward]].min
    steps[forward] -= cancelling
    steps[backward] -= cancelling
  end
end

def simplify_between(steps)
  ['n', 'ne', 'se', 's', 'sw', 'nw', 'n', 'ne'].each_cons(3) do |dirs|
    combinable = [steps[dirs[0]], steps[dirs[2]]].min
    steps[dirs[0]] -= combinable
    steps[dirs[1]] += combinable
    steps[dirs[2]] -= combinable
  end
end

input = File.read(File.dirname(__FILE__) + '/input').chomp

def simplify(steps)
  simplify_oposite(steps)
  simplify_between(steps)
end


null_path = {
  'n' => 0,
  'ne' => 0,
  'se' => 0,
  's' => 0,
  'sw' => 0,
  'nw' => 0,
}
steps = null_path.merge(input.split(',').group_by(&:itself).transform_values(&:length).to_h)

simplify(steps)
puts steps.values.inject(&:+)

steps = null_path
max_dist = 0
input.split(',').each do |step|
  steps[step] += 1
  simplify(steps)
  max_dist = [max_dist, steps.values.inject(&:+)].max
end
puts max_dist