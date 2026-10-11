import java
import orion_java
import orion_spring
import orion_mongo

/** Persistent domain type according to the selected adapter composition. */
predicate isEntity(Class entity) {
  isMongoDocument(entity)
}

predicate frameworkEntityMetadataAnnotation(Class entity, Annotation annotation) {
  isMongoEntityMetadataAnnotation(entity, annotation)
}

predicate isFrameworkCollectionNameCall(
  MethodCall call, StringLiteral collectionName, Class entity
) {
  isMongoCollectionNameCall(call, collectionName, entity)
}

predicate isQuery(Annotation annotation) {
  isMongoQuery(annotation)
}

predicate isNamedQuery(Annotation annotation) {
  annotation.getType().hasQualifiedName("orionflow.disabled", "NamedQuery")
}

predicate isEmbeddable(Class cls) {
  cls.hasQualifiedName("orionflow.disabled", "Embeddable")
}

predicate isEmbeddedField(Field field) {
  field.getDeclaringType().hasQualifiedName("orionflow.disabled", "Embedded")
}

predicate usesField(Expr queryValue, Field field) {
  mongoQueryReferencesField(queryValue, field)
}

predicate frameworkQueryReferencesField(Annotation query, Field field) {
  isMongoDocument(field.getDeclaringType()) and
  isMongoQuery(query) and
  mongoQueryReferencesField(query.getValue("value"), field)
}

predicate isCreateQuery(MethodCall call) {
  call.getMethod().hasQualifiedName("orionflow.disabled", "EntityManager", "createQuery")
}

predicate isCreateNamedQuery(MethodCall call) {
  call.getMethod().hasQualifiedName("orionflow.disabled", "EntityManager", "createNamedQuery")
}

predicate frameworkMetadataReferencesField(Annotation annotation, Field field) {
  isMongoDocument(field.getDeclaringType()) and
  mongoMetadataReferencesField(annotation, field)
}

predicate isFrameworkFieldNameCall(
  MethodCall call, StringLiteral propertyName, Field field
) {
  isMongoDocument(field.getDeclaringType()) and
  isMongoFieldNameCall(call, propertyName, field)
}

predicate isAssociationAnnotation(Annotation annotation) {
  isMongoAssociationAnnotation(annotation)
}

predicate isReferenceMappingAnnotation(Annotation annotation, Field field) {
  isMongoReferenceMappingAnnotation(annotation, field)
}

predicate isRelationshipField(Field field) {
  isMongoRelationshipField(field)
}

predicate isRelatedField(Field relationshipField, Field mappedField) {
  isMongoRelatedField(relationshipField, mappedField)
}

predicate usesRelationship(Expr queryValue, Field relationshipField) {
  mongoRelationshipReferencedInQuery(queryValue, relationshipField)
}

predicate frameworkQueryReferencesRelationship(
  Annotation query, Expr queryValue, Field relationshipField
) {
  isMongoQuery(query) and
  mongoRelationshipReferencedInQuery(queryValue, relationshipField)
}

Field getRelationshipField(Class sourceEntity, string relationshipName) {
  result = getMongoRelationshipField(sourceEntity, relationshipName)
}

predicate getRelationshipMappingAnnotation(
  Field field, string relationshipName, Annotation mapping
) {
  getMongoRelationshipMappingAnnotation(field, relationshipName, mapping)
}

predicate isIdAnnotation(Annotation annotation) {
  isMongoIdAnnotation(annotation)
}

predicate isGeneratedValueAnnotation(Annotation annotation) {
  annotation.getType().hasQualifiedName("orionflow.disabled", "GeneratedValue")
}

predicate isJoinColumnAnnotation(Annotation annotation) {
  annotation.getType().hasQualifiedName("orionflow.disabled", "JoinColumn")
}
