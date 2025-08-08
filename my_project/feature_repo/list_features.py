from feast import FeatureStore

store = FeatureStore(repo_path=".")
feature_views = store.list_feature_views()

for fv in feature_views:
    print(f"FeatureView: {fv.name}")
    for feature in fv.features:
        print(f"  Feature: {feature.name} ({feature.dtype})")

