import SwiftUI
import UI

struct ObjectiveCard: View {
    
    let objective: LibraryViewModelState<LearningObjective>
    let buttonAction: () -> Void
    
    var body: some View {
        resultView
        .padding()
        .background(Color ("CardBackground"))
        .cornerRadius(14)
    }
    
    private var resultView: some View {
        Group {
            switch objective {
            case .loading, .empty:
                LoadingView()
            case .error:
                Text("Error")
            case let .result(objective):
                contentView(learningObjective: objective)
            }
        }
    }
    
    private func contentView(learningObjective objective: LearningObjective) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack (alignment: .leading) {
                    Text(objective.code)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                    Text(objective.isCore ? "Core" : "Elective")
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Spacer()
                Button("Learned") {
                    buttonAction()
                }
                .buttonStyle(LearnedButtonStyle(isHightlighted: objective.isComplete))
            }
            .padding(.bottom, 20)
            Text(objective.description)
        }
    }
}

#if DEBUG

struct ObjectiveCard_Previews: PreviewProvider {
    static var previews: some View {
        ObjectiveCard(
            objective: .result(.fixture()),
            buttonAction: {})
    }
}

#endif
