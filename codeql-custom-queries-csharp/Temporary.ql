import csharp

//from File f
//where f.getRelativePath() = "src/Common/Diagnostics/Logging/Default/TelemetryLog.cs"
//select f.getRelativePath(), f

/*
from MethodCall c
where c.getFile().getRelativePath() = "src/Common/Diagnostics/Logging/Default/TelemetryLog.cs"
select c.getFile(), c.getTarget().getQualifiedName(), c
*/

/*
from Constructor c
where c.hasQualifiedName("System.Diagnostics.Tracing.EventSource.EventSource")
select c, c.getFile(), c.getQualifiedName()
*/

/*
from ConstructorInitializer i
where i.getFile().getRelativePath() = "src/Common/Diagnostics/Logging/TelemetryEventSource.cs"
select i, i.getTarget().getQualifiedName()
*/

/*
// find Microsoft.Windows.Test.UndirectedStress in constructor parameter
from StringLiteral s
where s.getValue() = "Microsoft.Windows.Test.UndirectedStress"
select s, s.getParent()
*/

// need to handle attribute setting of eventprovider (EventSourceAttribute)
/*
from Call c
where c.getTarget().getQualifiedName() = "System.Diagnostics.Tracing.EventSource.EventSource"
select c
*/

/*
from Constructor c
where c.getQualifiedName() = "System.Diagnostics.Tracing.EventSource.EventSource"
 and c.getAParameter().getName() = "eventSourceName"
select c, c.getQualifiedNameWithTypes()
*/

/*
from Call c, Parameter p
where c.getTarget().getQualifiedName() = "System.Diagnostics.Tracing.EventSource.EventSource"
 and p.getName() = "eventSourceName"
select c, c.getArgumentForParameter(p), c.getRuntimeArgumentForParameter(p)
*/

// Tests for dataflow
// constructor calls
/*
from Call c
where c.getTarget().(Constructor).getDeclaringType().hasQualifiedName("System.Diagnostics.Tracing.EventSource")
 and exists(c.getArgumentForName("eventSourceName"))
select c
*/

/*
class Configuration extends DataFlow::Configuration {
    Configuration() { this="String to eventName parameter" }
  
    override predicate isSource(DataFlow::Node src) {
      src.asExpr().hasValue()
    }
  
    override predicate isSink(DataFlow::Node sink) {
      exists(Call c | c.getTarget().(Constructor).getDeclaringType().hasQualifiedName("System.Diagnostics.Tracing.EventSource")
      and sink.asExpr() = c.getArgumentForName("eventSourceName"))
    }
  }

from DataFlow::Node src, DataFlow::Node sink, Configuration config
where config.hasFlow(src, sink)
select src, sink
*/

/*
class Configuration extends DataFlow::Configuration {
  Configuration() { this="String to eventName parameter" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().hasValue()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Call c | c.getTarget().(Constructor).getDeclaringType().hasQualifiedName("System.Diagnostics.Tracing.EventSource")
    and sink.asExpr() = c.getArgumentForName("eventSourceName"))
  }
}

from DataFlow::Node src, DataFlow::Node sink, Configuration config
where config.hasFlow(src, sink)
select src, sink
*/

/*
from Call c
where c.getTarget().(Method).getAParameter().getName() = "eventName"
 and c.getTarget().(Method).getDeclaringType().hasQualifiedName("System.Diagnostics.Tracing.EventSource")
select c
*/

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