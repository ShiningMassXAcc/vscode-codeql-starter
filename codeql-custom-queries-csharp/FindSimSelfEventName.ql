import csharp

class Configuration extends DataFlow::Configuration {
    Configuration() { this="String to eventName parameter" }
  
    override predicate isSource(DataFlow::Node src) {
      src.asExpr().hasValue()
    }
  
    override predicate isSink(DataFlow::Node sink) {
      exists(Call c | c.getTarget().(Method).getDeclaringType().hasQualifiedName("System.Diagnostics.Tracing.EventSource")
      and sink.asExpr() = c.getArgumentForName("eventName"))
    }
  }
  
  from DataFlow::Node src, DataFlow::Node sink, Configuration config
  where config.hasFlow(src, sink)
  select src, src.getLocation(), sink