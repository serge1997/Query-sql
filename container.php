<?php
class Loader
{
    public $bindings = array(
        "Pessoa" => Pessoa::class,
        "Car"    => Car::class
    );
}
class Container
{
    protected $instance = [];
    protected Loader $binding;
    
    public function __construct()
    {
        $this->binding = new Loader;
    }
    public function get($classname)
    {
        if (!isset($this->instance[$classname])){
            $this->bind($classname, $classname);
            $this->instance[$classname] = new $classname;
        }
        return $this->instance[$classname];
    }
    
    public function bind($key)
    {
        if (!array_key_exists($key, $this->binding->bindings)){
            echo "Class dont exist";
            exit;
        }
        $this->binding->bindings[$key];
    }
    
}

class Pessoa
{
    public $name;
	public function sayHello()
	{
		echo "Hello world \n";
	}
	
	public function func()
	{
	    echo "Another function\n";
	}
}

class Car
{
    public function cor()
    {
        echo "The car is red";
    }
}
$name = "";
$container = new Container();
$pessoa = $container->get("Pessoa");
$car = $container->get("Car");
$pessoa->sayHello();
$pessoa->func();
$car->cor();
?>
