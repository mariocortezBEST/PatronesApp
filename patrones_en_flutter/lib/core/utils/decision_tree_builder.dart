import '../models/decision_node.dart';
import '../models/design_pattern.dart';

class DecisionTree {
  final Map<int, DecisionNode> _nodes;

  DecisionTree(this._nodes);

  DecisionNode? getNodeById(int id) => _nodes[id];

  DesignPattern? findPatternByName(String name) {
    for (var node in _nodes.values) {
      if (node.isLeaf && node.pattern!.name == name) {
        return node.pattern;
      }
    }
    return null;
  }
}

// --- Definición de TODOS los Patrones de Diseño del GoF ---
final _patterns = {
  // --- CREACIONALES ---
  'Factory Method': DesignPattern(
      name: 'Factory Method', 
      category: 'Creacional', 
      description: 'Define una interfaz para crear un objeto, pero deja que las subclases decidan qué clase instanciar.', 
      whenToUse: 'Cuando una clase no puede anticipar la clase de objetos que debe crear.', 
      javaCodeExample: """
// Interfaz del Producto
interface Document {
    void open();
}
// Productos Concretos
class TextDocument implements Document {
    public void open() { System.out.println("Abriendo documento de texto."); }
}
class PdfDocument implements Document {
    public void open() { System.out.println("Abriendo documento PDF."); }
}
// Creador (Factory)
abstract class Application {
    // El "Factory Method"
    public abstract Document createDocument();
    
    public void newDocument() {
        Document doc = createDocument();
        doc.open();
    }
}
// Creadores Concretos
class WordProcessor extends Application {
    public Document createDocument() { return new TextDocument(); }
}
class PdfViewer extends Application {
    public Document createDocument() { return new PdfDocument(); }
}
""", 
      comparison: 'Similar a Abstract Factory, pero este último crea familias de objetos.'),
  'Abstract Factory': DesignPattern(
    name: 'Abstract Factory',
    category: 'Creacional',
    description: 'Proporciona una interfaz para crear familias de objetos relacionados o dependientes sin especificar sus clases concretas.',
    whenToUse: 'Cuando tu sistema debe ser independiente de cómo se crean, componen y representan sus productos, y cuando estás configurando el sistema con una de varias familias de productos.',
    javaCodeExample: """
// Fábrica Abstracta
interface GUIFactory {
    Button createButton();
    Checkbox createCheckbox();
}
// Productos Abstractos
interface Button { void paint(); }
interface Checkbox { void paint(); }
// Fábricas Concretas
class WinFactory implements GUIFactory {
    public Button createButton() { return new WinButton(); }
    public Checkbox createCheckbox() { return new WinCheckbox(); }
}
class MacFactory implements GUIFactory {
    public Button createButton() { return new MacButton(); }
    public Checkbox createCheckbox() { return new MacCheckbox(); }
}
// Productos Concretos
class WinButton implements Button { public void paint() { System.out.println("Button Windows"); } }
class MacButton implements Button { public void paint() { System.out.println("Button macOS"); } }
class WinCheckbox implements Checkbox { public void paint() { System.out.println("Checkbox Windows"); } }
class MacCheckbox implements Checkbox { public void paint() { System.out.println("Checkbox macOS"); } }
""",
    comparison: 'A menudo se implementa usando el patrón Factory Method, pero su propósito es crear familias de objetos, no un solo tipo de objeto.'
  ),
  'Builder': DesignPattern(
      name: 'Builder', 
      category: 'Creacional', 
      description: 'Separa la construcción de un objeto complejo de su representación.', 
      whenToUse: 'Cuando el constructor de una clase tiene demasiados parámetros.', 
      javaCodeExample: """
class Pizza {
    private final String dough, sauce, topping;
    private Pizza(Builder builder) {
        this.dough = builder.dough;
        this.sauce = builder.sauce;
        this.topping = builder.topping;
    }
    public static class Builder {
        private String dough = "normal", sauce = "tomate", topping;
        public Builder(String topping) { this.topping = topping; }
        public Builder withDough(String dough) { this.dough = dough; return this; }
        public Builder withSauce(String sauce) { this.sauce = sauce; return this; }
        public Pizza build() { return new Pizza(this); }
    }
}
""", 
      comparison: 'Builder se enfoca en construir un objeto paso a paso, a diferencia de las fábricas que lo crean de una sola vez.'),
  'Prototype': DesignPattern(
    name: 'Prototype',
    category: 'Creacional',
    description: 'Especifica los tipos de objetos a crear mediante una instancia prototípica, y crea nuevos objetos copiando este prototipo.',
    whenToUse: 'Cuando crear un objeto es costoso (ej: requiere acceso a base de datos o red) y es más eficiente clonar uno existente.',
    javaCodeExample: """
interface Shape extends Cloneable {
   Object clone();
   void draw();
}
class Rectangle implements Shape {
    public Object clone() {
        Object clone = null;
        try { clone = super.clone(); } catch (CloneNotSupportedException e) { e.printStackTrace(); }
        return clone;
    }
    public void draw() { System.out.println("Dibujando un Rectángulo"); }
}
""",
    comparison: 'A diferencia de Factory Method, que requiere una nueva subclase para cada tipo de producto, Prototype puede producir nuevos objetos simplemente clonando un prototipo.'
  ),
  'Singleton': DesignPattern(
      name: 'Singleton', 
      category: 'Creacional', 
      description: 'Asegura que una clase solo tenga una instancia y proporciona un punto de acceso global a ella.', 
      whenToUse: 'Cuando debe haber exactamente una instancia de una clase accesible globalmente.', 
      javaCodeExample: """
class DatabaseManager {
    private static DatabaseManager instance;
    private DatabaseManager() { }
    public static DatabaseManager getInstance() {
        if (instance == null) {
            instance = new DatabaseManager();
        }
        return instance;
    }
}
""", 
      comparison: 'Garantiza una instancia única, mientras que otros patrones creacionales se centran en la flexibilidad de la creación.'),
  
  // --- ESTRUCTURALES ---
  'Adapter': DesignPattern(
      name: 'Adapter', 
      category: 'Estructural', 
      description: 'Convierte la interfaz de una clase en otra interfaz que los clientes esperan.', 
      whenToUse: 'Cuando quieres usar una clase existente, pero su interfaz no coincide con la que necesitas.', 
      javaCodeExample: """
// Interfaz esperada por el cliente
interface MediaPlayer {
   void play(String fileName);
}
// Clase con interfaz incompatible
class AdvancedPlayer {
   void playMp4(String fileName) { System.out.println("Playing mp4: " + fileName); }
}
// Adaptador
class PlayerAdapter implements MediaPlayer {
   AdvancedPlayer advancedPlayer = new AdvancedPlayer();
   public void play(String fileName) {
      advancedPlayer.playMp4(fileName);
   }
}
""", 
      comparison: 'Adapter cambia la interfaz de un objeto existente; Decorator le añade responsabilidades.'),
  'Bridge': DesignPattern(
      name: 'Bridge',
      category: 'Estructural',
      description: 'Desacopla una abstracción de su implementación para que las dos puedan variar independientemente.',
      whenToUse: 'Cuando quieres evitar un enlace permanente entre una abstracción y su implementación.',
      javaCodeExample: """
// Implementador
interface DrawAPI {
    void drawCircle(int radius);
}
// Implementadores Concretos
class RedCircle implements DrawAPI {
    public void drawCircle(int radius) { System.out.println("Círculo Rojo, radio: " + radius); }
}
// Abstracción
abstract class Shape {
    protected DrawAPI drawAPI;
    protected Shape(DrawAPI drawAPI){ this.drawAPI = drawAPI; }
    public abstract void draw();	
}
// Abstracción Refinada
class Circle extends Shape {
    private int radius;
    public Circle(int radius, DrawAPI drawAPI) { super(drawAPI); this.radius = radius; }
    public void draw() { drawAPI.drawCircle(radius); }
}
""",
      comparison: 'Mientras que Adapter trabaja con clases existentes, Bridge se usa desde el principio, separando la abstracción de la implementación.'
  ),
  'Composite': DesignPattern(
      name: 'Composite',
      category: 'Estructural',
      description: 'Compone objetos en estructuras de árbol para representar jerarquías de parte-todo.',
      whenToUse: 'Cuando quieres representar jerarquías de objetos y que los clientes traten a los objetos individuales y compuestos de la misma manera.',
      javaCodeExample: """
import java.util.ArrayList;
import java.util.List;
// Componente
interface Graphic {
    void print();
}
// Hoja (Leaf)
class Ellipse implements Graphic {
    public void print() { System.out.println("Ellipse"); }
}
// Compuesto (Composite)
class CompositeGraphic implements Graphic {
    private List<Graphic> childGraphics = new ArrayList<>();
    public void print() {
        for (Graphic graphic : childGraphics) { graphic.print(); }
    }
    public void add(Graphic graphic) { childGraphics.add(graphic); }
}
""",
      comparison: 'Decorator es a menudo usado con Composite. Decorator añade responsabilidades, mientras que Composite se enfoca en la estructura jerárquica.'
  ),
  'Decorator': DesignPattern(
      name: 'Decorator', 
      category: 'Estructural', 
      description: 'Añade responsabilidades adicionales a un objeto de forma dinámica.', 
      whenToUse: 'Cuando quieres añadir funcionalidades a objetos individuales de forma dinámica y transparente.', 
      javaCodeExample: """
interface Coffee {
    String getDescription();
}
class SimpleCoffee implements Coffee {
    public String getDescription() { return "Café simple"; }
}
abstract class CoffeeDecorator implements Coffee {
    protected Coffee decoratedCoffee;
    public CoffeeDecorator(Coffee c){ this.decoratedCoffee = c; }
    public String getDescription() { return decoratedCoffee.getDescription(); }
}
class WithMilk extends CoffeeDecorator {
    public WithMilk(Coffee c) { super(c); }
    public String getDescription() { return super.getDescription() + ", con leche"; }
}
""", 
      comparison: 'Adapter cambia la interfaz, Decorator la mejora sin cambiarla.'),
  'Facade': DesignPattern(
      name: 'Facade', 
      category: 'Estructural', 
      description: 'Proporciona una interfaz unificada y simplificada a un conjunto de interfaces en un subsistema.', 
      whenToUse: 'Cuando quieres proporcionar una interfaz simple a un subsistema complejo.', 
      javaCodeExample: """
class CPU { public void processData() { System.out.println("CPU procesando"); } }
class Memory { public void load() { System.out.println("Memoria cargada"); } }

class ComputerFacade {
    private CPU processor = new CPU();
    private Memory memory = new Memory();
    public void start() {
        memory.load();
        processor.processData();
        System.out.println("Computadora iniciada.");
    }
}
""", 
      comparison: 'Facade simplifica una interfaz, Adapter la adapta.'),
  'Flyweight': DesignPattern(
      name: 'Flyweight',
      category: 'Estructural',
      description: 'Usa el uso compartido para soportar grandes cantidades de objetos de grano fino de manera eficiente.',
      whenToUse: 'Cuando una aplicación usa un gran número de objetos que tienen partes en común.',
      javaCodeExample: """
import java.util.HashMap;
// Flyweight
interface Character { void printCharacter(); }
// ConcreteFlyweight
class ConcreteCharacter implements Character {
    private char intrinsicState;
    public ConcreteCharacter(char c) { this.intrinsicState = c; }
    public void printCharacter() { System.out.println("Char: " + intrinsicState); }
}
// FlyweightFactory
class CharacterFactory {
    private HashMap<Character, Character> characters = new HashMap<>();
    public Character getCharacter(char key) {
        if (!characters.containsKey(key)) {
            characters.put(key, new ConcreteCharacter(key));
        }
        return characters.get(key);
    }
}
""",
      comparison: 'A diferencia de Singleton, que garantiza una sola instancia en total, Flyweight permite múltiples instancias de objetos compartidos.'
  ),
  'Proxy': DesignPattern(
      name: 'Proxy',
      category: 'Estructural',
      description: 'Proporciona un sustituto o marcador de posición para otro objeto para controlar el acceso a él.',
      whenToUse: 'Cuando necesitas una referencia más versátil a un objeto (ej. para carga perezosa, control de acceso).',
      javaCodeExample: """
// Sujeto
interface Image { void display(); }
// Sujeto Real
class RealImage implements Image {
    private String fileName;
    public RealImage(String fileName){ this.fileName = fileName; loadFromDisk(); }
    public void display() { System.out.println("Mostrando " + fileName); }
    private void loadFromDisk(){ System.out.println("Cargando " + fileName); }
}
// Proxy
class ProxyImage implements Image {
    private RealImage realImage;
    private String fileName;
    public ProxyImage(String fileName){ this.fileName = fileName; }
    public void display() {
        if(realImage == null){ realImage = new RealImage(fileName); }
        realImage.display();
    }
}
""",
      comparison: 'Adapter proporciona una interfaz diferente, mientras que Proxy proporciona la misma interfaz. Decorator añade responsabilidades, Proxy controla el acceso.'
  ),

  // --- COMPORTAMIENTO ---
  'Chain of Responsibility': DesignPattern(
      name: 'Chain of Responsibility',
      category: 'Comportamiento',
      description: 'Evita acoplar el remitente de una solicitud a su receptor al dar a más de un objeto la oportunidad de manejar la solicitud.',
      whenToUse: 'Cuando más de un objeto puede manejar una solicitud, y el manejador no se conoce a priori.',
      javaCodeExample: """
abstract class Logger {
    protected Logger nextLogger;
    public void setNextLogger(Logger logger){ this.nextLogger = logger; }
    public void logMessage(String message){
        log(message);
        if(nextLogger !=null){ nextLogger.logMessage(message); }
    }
    abstract protected void log(String message);
}
class ConsoleLogger extends Logger {
    protected void log(String message) { System.out.println("Consola: " + message); }
}
""",
      comparison: 'A diferencia de Command, que encapsula una operación, Chain of Responsibility la pasa a través de una cadena de posibles manejadores.'
  ),
  'Command': DesignPattern(
      name: 'Command',
      category: 'Comportamiento',
      description: 'Encapsula una solicitud como un objeto, lo que le permite parametrizar clientes con diferentes solicitudes y colas.',
      whenToUse: 'Cuando quieres parametrizar objetos por una acción a realizar.',
      javaCodeExample: """
interface Command { void execute(); }
class Light {
    public void on() { System.out.println("Luz encendida"); }
}
class LightOnCommand implements Command {
    Light light;
    public LightOnCommand(Light light){ this.light = light; }
    public void execute() { light.on(); }
}
class RemoteControl {
    private Command command;
    public void setCommand(Command c){ this.command = c; }
    public void pressButton(){ command.execute(); }
}
""",
      comparison: 'Mientras que Chain of Responsibility pasa una solicitud, Command la encapsula. Memento a menudo se usa con Command para guardar el estado para deshacer.'
  ),
  'Iterator': DesignPattern(
      name: 'Iterator', 
      category: 'Comportamiento', 
      description: 'Proporciona una forma de acceder a los elementos de un objeto agregado secuencialmente sin exponer su representación subyacente.', 
      whenToUse: 'Cuando necesitas acceder al contenido de una colección sin exponer su estructura interna.', 
      javaCodeExample: """
import java.util.ArrayList;
import java.util.List;
interface Iterator { boolean hasNext(); Object next(); }
interface Container { Iterator getIterator(); }

class NameRepository implements Container {
    public String names[] = {"Robert" , "John" ,"Julie"};
    @Override
    public Iterator getIterator() { return new NameIterator(); }
    private class NameIterator implements Iterator {
        int index;
        @Override
        public boolean hasNext() { return index < names.length; }
        @Override
        public Object next() {
            if(this.hasNext()){ return names[index++]; }
            return null;
        }		
    }
}
""", 
      comparison: 'Composite es a menudo recorrido por un Iterator.'),
  'Mediator': DesignPattern(
      name: 'Mediator',
      category: 'Comportamiento',
      description: 'Define un objeto que encapsula cómo un conjunto de objetos interactúan.',
      whenToUse: 'Cuando un conjunto de objetos se comunican de manera compleja, lo que resulta en un sistema difícil de entender y mantener.',
      javaCodeExample: """
class ChatRoom {
   public static void showMessage(User user, String message){
      System.out.println("[" + user.getName() + "] : " + message);
   }
}
class User {
   private String name;
   public User(String name){ this.name  = name; }
   public String getName() { return name; }
   public void sendMessage(String message){ ChatRoom.showMessage(this, message); }
}
""",
      comparison: 'Observer distribuye la comunicación notificando a los suscriptores, mientras que Mediator centraliza la comunicación entre colegas.'
  ),
  'Memento': DesignPattern(
      name: 'Memento',
      category: 'Comportamiento',
      description: 'Sin violar la encapsulación, captura y externaliza el estado interno de un objeto para que pueda ser restaurado a este estado más tarde.',
      whenToUse: 'Cuando necesitas poder guardar y restaurar el estado de un objeto.',
      javaCodeExample: """
class Memento {
   private String state;
   public Memento(String state){ this.state = state; }
   public String getState(){ return state; }	
}
class Originator {
   private String state;
   public void setState(String state){ this.state = state; }
   public Memento saveStateToMemento(){ return new Memento(state); }
   public void getStateFromMemento(Memento m){ state = m.getState(); }
}
class CareTaker {
   private java.util.List<Memento> mementoList = new java.util.ArrayList<>();
   public void add(Memento state){ mementoList.add(state); }
   public Memento get(int i){ return mementoList.get(i); }
}
""",
      comparison: 'Command puede usar Memento para mantener el estado necesario para una operación de deshacer.'
  ),
  'Observer': DesignPattern(
      name: 'Observer', 
      category: 'Comportamiento', 
      description: 'Define una dependencia uno-a-muchos entre objetos para que cuando un objeto cambia de estado, todos sus dependientes son notificados.', 
      whenToUse: 'Cuando un cambio en un objeto requiere cambiar otros, y no sabes cuántos objetos necesitan ser cambiados.', 
      javaCodeExample: """
import java.util.ArrayList;
import java.util.List;
interface Subject {
    void register(Observer obj);
    void notifyObservers();
}
interface Observer {
    void update(String message);
}
class NewsAgency implements Subject {
    private List<Observer> channels = new ArrayList<>();
    private String news;
    public void setNews(String news) {
        this.news = news;
        notifyObservers();
    }
    public void register(Observer channel) { channels.add(channel); }
    public void notifyObservers() {
        for(Observer channel : this.channels) {
            channel.update(this.news);
        }
    }
}
class NewsChannel implements Observer {
    public void update(String news) { System.out.println("Noticia de última hora: " + news); }
}
""", 
      comparison: 'Mediator encapsula la comunicación; Observer la distribuye.'),
  'State': DesignPattern(
      name: 'State',
      category: 'Comportamiento',
      description: 'Permite que un objeto altere su comportamiento cuando su estado interno cambia. El objeto parecerá cambiar su clase.',
      whenToUse: 'Cuando el comportamiento de un objeto depende de su estado, y debe cambiar su comportamiento en tiempo de ejecución.',
      javaCodeExample: """
interface State { void doAction(Context context); }
class StartState implements State {
    public void doAction(Context context) {
        System.out.println("En estado de inicio");
        context.setState(this);	
    }
}
class StopState implements State {
    public void doAction(Context context) {
        System.out.println("En estado de parada");
        context.setState(this);
    }
}
class Context {
   private State state;
   public Context(){ state = null; }
   public void setState(State state){ this.state = state; }
}
""",
      comparison: 'Mientras que Strategy se enfoca en algoritmos intercambiables, State se enfoca en cambiar el comportamiento de un objeto en función de su estado interno.'
  ),
  'Strategy': DesignPattern(
      name: 'Strategy', 
      category: 'Comportamiento', 
      description: 'Define una familia de algoritmos, los encapsula y los hace intercambiables.', 
      whenToUse: 'Cuando tienes muchas clases relacionadas que se diferencian solo en su comportamiento.', 
      javaCodeExample: """
interface PaymentStrategy {
    void pay(int amount);
}
class CreditCardPayment implements PaymentStrategy {
    public void pay(int amount) { System.out.println("Pagado " + amount + " con Tarjeta de Crédito."); }
}
class PayPalPayment implements PaymentStrategy {
    public void pay(int amount) { System.out.println("Pagado " + amount + " con PayPal."); }
}
class ShoppingCart {
    private PaymentStrategy paymentStrategy;
    public void setPaymentStrategy(PaymentStrategy s) { this.paymentStrategy = s; }
    public void checkout(int amount) { paymentStrategy.pay(amount); }
}
""", 
      comparison: 'State puede ser visto como una extensión de Strategy. Ambos se basan en la composición para cambiar el comportamiento.'),
  'Template Method': DesignPattern(
      name: 'Template Method',
      category: 'Comportamiento',
      description: 'Define el esqueleto de un algoritmo en una operación, difiriendo algunos pasos a las subclases.',
      whenToUse: 'Para implementar las partes invariantes de un algoritmo una sola vez y dejar que las subclases implementen el comportamiento que puede variar.',
      javaCodeExample: """
abstract class Game {
   abstract void initialize();
   abstract void startPlay();
   abstract void endPlay();
   public final void play(){
      initialize();
      startPlay();
      endPlay();
   }
}
class Cricket extends Game {
   void endPlay() { System.out.println("Juego de Cricket Finalizado!"); }
   void initialize() { System.out.println("Juego de Cricket Inicializado!"); }
   void startPlay() { System.out.println("Juego de Cricket Iniciado!"); }
}
""",
      comparison: 'Factory Method es una especialización de Template Method. A su vez, los Template Methods pueden usar Factory Methods.'
  ),
  'Visitor': DesignPattern(
      name: 'Visitor',
      category: 'Comportamiento',
      description: 'Representa una operación a realizar sobre los elementos de una estructura de objetos.',
      whenToUse: 'Cuando necesitas realizar muchas operaciones no relacionadas en los objetos de una estructura.',
      javaCodeExample: """
interface ComputerPart { void accept(ComputerPartVisitor v); }
class Keyboard implements ComputerPart {
   public void accept(ComputerPartVisitor v) { v.visit(this); }
}
interface ComputerPartVisitor {
	void visit(Keyboard keyboard);
}
class ComputerPartDisplayVisitor implements ComputerPartVisitor {
   public void visit(Keyboard k) { System.out.println("Mostrando Teclado."); }
}
""",
      comparison: 'Visitor puede recorrer una estructura Composite. Permite añadir operaciones a las clases Composite sin cambiarlas.'
  ),
};

// --- Construcción del Árbol de Decisiones Completo ---
final DecisionTree decisionTree = DecisionTree({
  // NODO 0: INICIO
  0: DecisionNode(
    id: 0,
    question: '¿Cuál es la principal preocupación de tu problema de diseño?',
    answers: {
      'Creación de objetos de forma flexible.': 1,
      'Cómo se comunican y relacionan los objetos.': 2,
      'Estructura y composición de clases y objetos.': 3,
    },
  ),
  
  // --- RAMA CREACIONAL (ID 1XX) ---
  1: DecisionNode(
    id: 1,
    question: '¿Tu objetivo principal es sobre CÓMO se crean los objetos?',
    answers: {
      'Quiero delegar la instanciación a subclases.': 100, // Factory Method
      'Quiero asegurarme de que solo exista UNA instancia de una clase.': 101, // Singleton
      'Quiero construir un objeto complejo paso a paso.': 102, // Builder
      'Quiero crear familias de objetos que deben usarse juntos.': 103, // Abstract Factory
      'Quiero clonar un objeto existente en lugar de crearlo desde cero.': 104, // Prototype
    },
  ),
  100: DecisionNode(id: 100, question: '', answers: {}, pattern: _patterns['Factory Method']),
  101: DecisionNode(id: 101, question: '', answers: {}, pattern: _patterns['Singleton']),
  102: DecisionNode(id: 102, question: '', answers: {}, pattern: _patterns['Builder']),
  103: DecisionNode(id: 103, question: '', answers: {}, pattern: _patterns['Abstract Factory']),
  104: DecisionNode(id: 104, question: '', answers: {}, pattern: _patterns['Prototype']),
  
  // --- RAMA COMPORTAMIENTO (ID 2XX) ---
  2: DecisionNode(
    id: 2,
    question: 'El problema se enfoca en la comunicación y asignación de responsabilidades entre objetos. ¿Cuál describe mejor tu necesidad?',
    answers: {
      'Quiero que un objeto cambie su comportamiento según su estado interno.': 200, // State
      'Quiero encapsular una acción en un objeto (ej. para colas, deshacer).': 201, // Command
      'Quiero desacoplar la comunicación entre objetos.': 202,
      'Quiero definir un algoritmo y que las subclases implementen algunos pasos.': 203, // Template Method
      'Quiero iterar sobre una colección sin exponer su estructura interna.': 204, // Iterator
      'Quiero añadir nuevas operaciones a una estructura de objetos sin modificarla.': 205, // Visitor
      'Quiero poder guardar y restaurar el estado de un objeto.': 206, // Memento
      'Quiero intercambiar algoritmos completos en tiempo de ejecución.': 207, // Strategy
    },
  ),
  200: DecisionNode(id: 200, question: '', answers: {}, pattern: _patterns['State']),
  201: DecisionNode(id: 201, question: '', answers: {}, pattern: _patterns['Command']),
  202: DecisionNode(
    id: 202,
    question: '¿Cómo quieres gestionar el desacoplamiento?',
    answers: {
      'Pasando una solicitud por una cadena de objetos hasta que uno la maneje.': 210, // Chain of Responsibility
      'Centralizando la comunicación a través de un objeto mediador.': 211, // Mediator
      'Notificando a múltiples objetos sobre un cambio de estado en uno solo.': 212, // Observer
    }
  ),
  203: DecisionNode(id: 203, question: '', answers: {}, pattern: _patterns['Template Method']),
  204: DecisionNode(id: 204, question: '', answers: {}, pattern: _patterns['Iterator']),
  205: DecisionNode(id: 205, question: '', answers: {}, pattern: _patterns['Visitor']),
  206: DecisionNode(id: 206, question: '', answers: {}, pattern: _patterns['Memento']),
  207: DecisionNode(id: 207, question: '', answers: {}, pattern: _patterns['Strategy']),
  210: DecisionNode(id: 210, question: '', answers: {}, pattern: _patterns['Chain of Responsibility']),
  211: DecisionNode(id: 211, question: '', answers: {}, pattern: _patterns['Mediator']),
  212: DecisionNode(id: 212, question: '', answers: {}, pattern: _patterns['Observer']),

  // --- RAMA ESTRUCTURAL (ID 3XX) ---
  3: DecisionNode(
    id: 3,
    question: '¿Cómo quieres organizar y componer tus clases y objetos?',
    answers: {
      'Necesito que dos interfaces incompatibles puedan trabajar juntas.': 300, // Adapter
      'Quiero añadir nuevas funcionalidades a un objeto dinámicamente.': 301, // Decorator
      'Busco simplificar la interfaz de un sistema complejo.': 302, // Facade
      'Quiero tratar a un objeto individual y a una composición de objetos de la misma manera.': 303, // Composite
      'Quiero controlar el acceso a un objeto o añadirle funcionalidad (logging, lazy-loading).': 304, // Proxy
      'Quiero desacoplar la interfaz de la implementación.': 305, // Bridge
      'Quiero reducir el uso de memoria compartiendo objetos.': 306, // Flyweight
    }
  ),
  300: DecisionNode(id: 300, question: '', answers: {}, pattern: _patterns['Adapter']),
  301: DecisionNode(id: 301, question: '', answers: {}, pattern: _patterns['Decorator']),
  302: DecisionNode(id: 302, question: '', answers: {}, pattern: _patterns['Facade']),
  303: DecisionNode(id: 303, question: '', answers: {}, pattern: _patterns['Composite']),
  304: DecisionNode(id: 304, question: '', answers: {}, pattern: _patterns['Proxy']),
  305: DecisionNode(id: 305, question: '', answers: {}, pattern: _patterns['Bridge']),
  306: DecisionNode(id: 306, question: '', answers: {}, pattern: _patterns['Flyweight']),
});