import csharp

from MethodCall c
where c.getTarget().hasName("WriteEvent")

select c.getFile(), c.getTarget().getQualifiedName(), c