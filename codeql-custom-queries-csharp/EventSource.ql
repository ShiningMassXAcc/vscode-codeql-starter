import csharp

from MethodCall c
where c.getTarget().hasQualifiedName("System.Diagnostics.Tracing.EventSource.Write<T>")
select c.getFile(), c, c.getARuntimeTarget()