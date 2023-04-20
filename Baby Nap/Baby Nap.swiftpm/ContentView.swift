import SwiftUI

struct ContentView: View {
    @State private var date = Date()
    @State private var inputDate: Date = Date()
    @State private var inputGender = 0
    @State var inputName: String = ""
    @State var name: String = ""
    @State var dates: String = ""
    @State var gender: String = ""
    private var genderArea = ["Male", "Female"]
    @State var isActive: Bool = false
    
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
        }()
    
    @ObservedObject var dataViewModel = DataViewModel()

    
    var body: some View {
        if #available(iOS 16.0, *) {
            
            NavigationStack{
                VStack {
                    VStack{
                        Text ("BABY NAP")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 80)
                            .padding(.top, 15)
                    }
                    
                    ZStack{
                        VStack (alignment: .leading, spacing: 5) {
                            VStack{
                                Text("Hi Moms!")
                                Text("Please Input Your Child Data")
                                
                            }.font(.title3)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(20)
                            
                            VStack (alignment: .leading){
                                Text("Child Name")
                                    .padding(.horizontal,25)
                                    
                                TextField("", text: $inputName)
                                    .frame(height: 35)
                                    .background(.white)
                                    .cornerRadius(5)
                                    .padding(.horizontal,25)
                                    .padding(.bottom,15)
                            }.font(.title3)
                            
                            VStack (alignment: .leading){
                                Text("Gender")
                                    .padding(.horizontal,25)
                                    .font(.title3)
                                Picker(selection: $inputGender, label: EmptyView()) {
                                    ForEach       (0 ..< 2){
                                        Text(self.genderArea[$0])
                                            .font(.title3)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .background(.white)
                                .cornerRadius(5)
                                .padding(.horizontal,25)
                                .padding(.bottom,15)
                                
                            }
                            
                            VStack (alignment: .leading){
                                Text("Date of Birth")
                                    .padding(.horizontal,25)
                                    .font(.title3)
                                DatePicker("", selection: $inputDate, in: ...Date.now, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .fixedSize().frame( alignment: .leading)
                                    .background(.white)
                                    .cornerRadius(5)
                                    .padding(.horizontal,25)
                                    .padding(.bottom,15)
                            }.font(.title3)
                        }
                    }
                    VStack{
                        Spacer()
                        Button {
                            dataViewModel.addChild(DataModel(name: inputName, age: calculateAge(birthDate: inputDate), gender: genderArea[inputGender]))
                            print("tes")
//                            dataViewModel.reset()
                            isActive.toggle()
                        } label: {
                            
                                Text("Save")
                                    .frame(width: 350, height: 50)
                                    .frame(alignment: .center)
                                    .foregroundColor(.black)
                                    .font(.title2)
                                    .background(customColor.blueSoftColor)
                                    .cornerRadius(25)
                                    .shadow(radius: 0, y: 2)
                        }
                        NavigationLink(destination: mainView(isActive: $isActive), isActive: $isActive){
                        }
                        Spacer()
                    }
                } .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color("purple"), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    //.background(customColor.purpleColor)
                    //.background(LinearGradient(gradient: Gradient(colors: [Color("purple"), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(30)
                    .shadow(color:.gray,radius: 3, y: 2)
                    .padding(30)
            }.navigationBarBackButtonHidden(true)
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    func calculateAge(birthDate: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        let ageComponents = calendar.dateComponents([.day], from: birthDate, to: currentDate)

        print("\(ageComponents) days")

        return ageComponents.day ?? 0
    }
}

struct customColor{
    static let purpleColor = Color("purple")
    static let blueSoftColor = Color("blueSoft")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
