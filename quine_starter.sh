while true
do
  ruby quine.rb | tee quine_result
  mv quine_result quine.rb
  sleep 0.2
done
