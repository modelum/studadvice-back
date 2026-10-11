/**
 * This is an automatically generated file
 *
 * @name Reference Casted
 * @kind alert
 * @problem.severity warning
 * @id java/orion/reference-casted/0/0
 */
 
import java
import orion_dataflow
import utils

from Class entity, Field referenceField, Location usageLoc, string message,
     string oldType, string newType
where
  isEntity(entity) and
  entity.hasName("Step") and
  referenceField = entity.getAField() and
  referenceField.hasName("requiredDocuments") and
  oldType = referenceField.getType().getName() and
  newType = "String" and
  (
    usageLoc = referenceField.getLocation() and
    message = "Reference '" + referenceField.getName() + "' in entity '" +
      entity.getName() + "' will change type from '" + oldType + "' to '" +
      newType + "'."

    or
    exists(Method accessor |
      (isGetter(accessor, referenceField) or isSetter(accessor, referenceField)) and
      usageLoc = accessor.getLocation() and
      message = "Accessor '" + accessor.getName() +
        "' exposes the old reference type '" + oldType + "'."
    )

    or
    exists(MethodCall accessorCall |
      callsAccessor(accessorCall, referenceField) and
      usageLoc = accessorCall.getLocation() and
      message = "Call to reference accessor '" +
        accessorCall.getMethod().getName() + "' depends on old type '" +
        oldType + "'."
    )

    or
    exists(Expr expression |
      usesFieldWithTypeDependency(expression, referenceField) and
      usageLoc = expression.getLocation() and
      message = "Code uses reference '" + referenceField.getName() +
        "' as old type '" + oldType + "'."
    )

    or
    exists(LocalVariableDeclExpr variable, Expr source |
      source = variable.getInit() and
      readsFieldValue(source, referenceField) and
      variable.getType().getName() = oldType and
      oldType != newType and
      usageLoc = variable.getLocation() and
      message = "Variable declaration expects old reference type '" + oldType + "'."
    )

    or
    exists(Assignment assignment, Expr source |
      source = assignment.getRhs() and
      readsFieldValue(source, referenceField) and
      assignment.getDest().getType().getName() = oldType and
      oldType != newType and
      usageLoc = assignment.getLocation() and
      message = "Assignment expects old reference type '" + oldType + "'."
    )

    or
    exists(MethodCall call, Expr source, int i |
      source = call.getArgument(i) and
      readsFieldValue(source, referenceField) and
      call.getMethod().getParameterType(i).getName() = oldType and
      oldType != newType and
      usageLoc = call.getLocation() and
      message = "Method call expects old reference type '" + oldType + "'."
    )

    or
    exists(Annotation association |
      association = referenceField.getAnAnnotation() and
      isAssociationAnnotation(association) and
      usageLoc = association.getLocation() and
      message = "Persistence association for reference '" +
        referenceField.getName() + "' must be reviewed for type '" + newType + "'."
    )

    or
    exists(Annotation referenceMapping |
      isReferenceMappingAnnotation(referenceMapping, referenceField) and
      usageLoc = referenceMapping.getLocation() and
      message = "Reference mapping metadata for '" +
        referenceField.getName() + "' may depend on the old identifier type."
    )

    or
    exists(Class targetEntity, Field targetId, Annotation idAnnotation |
      fieldTargetsEntity(referenceField, targetEntity) and
      targetId = targetEntity.getAField() and
      idAnnotation = targetId.getAnAnnotation() and
      isIdAnnotation(idAnnotation) and
      targetId.getType().getName() = oldType and
      oldType != newType and
      usageLoc = targetId.getLocation() and
      message = "Referenced identifier '" + targetId.getName() +
        "' in entity '" + targetEntity.getName() +
        "' still has old type '" + oldType + "'."
    )

    or
    exists(Expr source, MethodCall consumer |
      fieldValueFlowsToOldTypeConsumer(referenceField, source, consumer) and
      usageLoc = consumer.getLocation() and
      message = "[Potential] Reference value from '" +
        referenceField.getName() + "' flows locally to old-type operation '" +
        consumer.getMethod().getName() + "'."
    )
  )
select usageLoc, message
